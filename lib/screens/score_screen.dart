import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../services/score_service.dart';
import '../services/scoring_value_service.dart';
import '../widgets/scoring_table.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final GlobalKey<ScoringTableState> _tableKey =
      GlobalKey<ScoringTableState>();

  int winnerIndex = -1;
  Map<String, List<int>> currentQuantities = {};

  Widget _buildScoreBoardTitle() => Transform.translate(
        offset: const Offset(-44, 0),
        child: SizedBox(
          width: ScoringTableState.titleGridWidth,
          child: const Center(
            child: Text(
              "🀄 Chea's Mahjong Score Board",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    ScoringValueService.instance.load().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _winnerChanged(int index) {
    final game = GameService.instance.currentGame;

    if (game == null) return;

    // An empty player name means the player is inactive.
    // Inactive players cannot be selected as the winner.
    if (game.players[index].name.trim().isEmpty) {
      return;
    }

    setState(() {
      winnerIndex = index;
    });

    _tableKey.currentState?.clearAll();
  }

  Future<void> _resetDefaultPoints() async {
    await _tableKey.currentState?.resetPointValues();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Point values reset to defaults.'),
      ),
    );
  }

  int _selectedBasePoints() {
    for (final rule in ScoringRules.baseRules) {
      if ((currentQuantities[rule.name]?[winnerIndex] ?? 0) > 0) {
        return ScoringValueService.instance.getPoints(rule.name);
      }
    }

    return 0;
  }

  bool _hasOutcome(String ruleName) =>
      (currentQuantities[ruleName]?[winnerIndex] ?? 0) > 0;

  Map<String, int> _selectedOutcomes() => {
        for (final rule in ScoringRules.bonusRules)
          if (_hasOutcome(rule.name)) rule.name: 1,
      };

  Future<void> _saveRound() async {
    final game = GameService.instance.currentGame;

    if (game == null) return;

    final basePoints = _selectedBasePoints();

    final activePlayerCount = game.players
        .where((player) => player.name.trim().isNotEmpty)
        .length;

    final loserCount = activePlayerCount - 1;

    final multiplier = _hasOutcome('Discarded Chip Mahjong')
        ? loserCount + 1
        : _hasOutcome('Self-draw Chip Mahjong')
            ? loserCount
            : 1;

    final scores = <int, int>{
      for (var index = 0; index < game.players.length; index++)
        game.players[index].id: index == winnerIndex
            ? basePoints * multiplier
            : 0,
    };

    final success = const ScoreService().applyHandScore(
      game: game,
      winnerId: game.players[winnerIndex].id,
      playerScores: scores,
      baseQuantities: currentQuantities,
      bonusQuantities: _selectedOutcomes(),
    );

    if (!success) return;

    await GameService.instance.saveCurrentGame();

    if (!mounted) return;

    FocusManager.instance.primaryFocus?.unfocus();

    _tableKey.currentState?.clearAll();
    currentQuantities.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Round saved'),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  Future<void> _undoLastRound() async {
    final game = GameService.instance.currentGame;

    if (game == null) return;

    if (!const ScoreService().undoLastHand(game: game)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing to undo.'),
          ),
        );
      }

      return;
    }

    await GameService.instance.saveCurrentGame();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Last round undone.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = GameService.instance.currentGame;

    if (winnerIndex == -1 && game != null) {
      final east = game.eastIndex;

      if (east >= 0 &&
          game.players[east].name.trim().isNotEmpty) {
        winnerIndex = east;
      } else {
        winnerIndex = game.players.indexWhere(
          (player) => player.name.trim().isNotEmpty,
        );

        if (winnerIndex == -1) {
          winnerIndex = 0;
        }
      }
    }

    if (game == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: _buildScoreBoardTitle(),
        ),
        body: const Center(
          child: Text('No active game.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: _buildScoreBoardTitle(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          const Divider(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ScoringTable(
                key: _tableKey,
                playerNames: game.players
                    .map((player) => player.name)
                    .toList(),
                runningTotals: game.players
                    .map((player) => player.score)
                    .toList(),
                winnerIndex: winnerIndex,
                onWinnerChanged: _winnerChanged,
                onPlayerNameChanged: (index, name) {
                  final trimmedName = name.trim();

                  // An inactive player must always be the highest-numbered
                  // inactive player.
                  if (trimmedName.isEmpty) {
                    for (var i = index + 1;
                        i < game.players.length;
                        i++) {
                      if (game.players[i].name.trim().isNotEmpty) {
                        return;
                      }
                    }
                  }

                  setState(() {
                    game.players[index].name = trimmedName;

                    // If the current winner becomes inactive,
                    // select the first remaining active player.
                    if (trimmedName.isEmpty && winnerIndex == index) {
                      winnerIndex = game.players.indexWhere(
                        (player) => player.name.trim().isNotEmpty,
                      );

                      if (winnerIndex == -1) {
                        winnerIndex = 0;
                      }
                    }
                  });

                  GameService.instance.saveCurrentGame();
                },

                onChanged: (values) {
                  currentQuantities = values.map(
                    (key, value) => MapEntry(
                      key,
                      List<int>.from(value),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                // 128 rule name
                // + 34 points
                // + 82 player 1
                // + 82 player 2
                //
                // This places the right edge of SAVE ROUND
                // exactly at the left edge of Player 3.
                width: 326,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _undoLastRound,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'UNDO',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: _resetDefaultPoints,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'RESET',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _saveRound,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'SAVE ROUND',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
  final GlobalKey<ScoringTableState> _tableKey = GlobalKey<ScoringTableState>();
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
      if (mounted) setState(() {});
    });
  }

  void _winnerChanged(int index) {
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
      const SnackBar(content: Text('Point values reset to defaults.')),
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
    final loserCount = game.players.length - 1;
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
    setState(() {});
    _tableKey.currentState?.clearAll();
    currentQuantities.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Round saved')));
  }

  Future<void> _undoLastRound() async {
    final game = GameService.instance.currentGame;
    if (game == null) return;
    if (!const ScoreService().undoLastHand(game: game)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nothing to undo.')));
      }
      return;
    }
    await GameService.instance.saveCurrentGame();
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Last round undone.')));
  }

  @override
  Widget build(BuildContext context) {
    final game = GameService.instance.currentGame;
    if (winnerIndex == -1) winnerIndex = game?.eastIndex ?? 0;
    if (game == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: _buildScoreBoardTitle(),
        ),
        body: const Center(child: Text('No active game.')),
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
                playerNames: game.players.map((player) => player.name).toList(),
                runningTotals: game.players
                    .map((player) => player.score)
                    .toList(),
                winnerIndex: winnerIndex,
                onWinnerChanged: _winnerChanged,
                onPlayerNameChanged: (index, name) {
                  setState(() => game.players[index].name = name);
                  GameService.instance.saveCurrentGame();
                },
                onChanged: (values) => currentQuantities = values.map(
                  (key, value) => MapEntry(key, List<int>.from(value)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: ScoringTableState.scoreGridWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _undoLastRound,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'UNDO',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: _resetDefaultPoints,
                        child: const Text(
                          'Reset Default',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _saveRound,
                        child: const Text(
                          'SAVE ROUND',
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

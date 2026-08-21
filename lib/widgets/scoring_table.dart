import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../services/scoring_value_service.dart';
import '../theme/player_colors.dart';
import 'player_header.dart';

class ScoringTable extends StatefulWidget {
  const ScoringTable({
    super.key,
    required this.playerNames,
    required this.runningTotals,
    required this.winnerIndex,
    required this.onWinnerChanged,
    required this.onChanged,
    required this.onPlayerNameChanged,
  });

  final List<String> playerNames;
  final List<int> runningTotals;
  final int winnerIndex;
  final ValueChanged<int> onWinnerChanged;
  final ValueChanged<Map<String, List<int>>> onChanged;
  final void Function(int playerIndex, String newName) onPlayerNameChanged;

  @override
  State<ScoringTable> createState() => ScoringTableState();
}

class ScoringTableState extends State<ScoringTable> {
  // Reduced from 128 to 110 to make the first column
  // approximately three characters narrower.
  static const double _ruleNameWidth = 110;
  static const double _pointsWidth = 34;
  static const double _playerColumnWidth = 82;

  static const double scoreGridWidth =
      _ruleNameWidth + _pointsWidth + (_playerColumnWidth * 4);

  static const double titleGridWidth =
      _ruleNameWidth + _pointsWidth + (_playerColumnWidth * 3);

  static const double _sectionTitleHeight = 24;
  static const double _rowHeight = 34;

  // Visual-only settings for the special outcome box.
  static const double _specialBoxRightTrim = 4;
  static const double _specialBoxRadius = 6;

  final Map<String, List<int>> _quantities = {};
  final Map<String, TextEditingController> _pointControllers = {};

  // Remembers the complete selection made by the most recent winner.
  // This includes both the Base Point pattern and the Mahjong outcome
  // (Self-draw / Discarded Chip). The selections are carried forward
  // to the next winner, including after SAVE ROUND.
  Map<String, int> _carryForwardSelections = {};

  // When the parent changes winner it currently calls clearAll(). The
  // parent rebuild happens after the callback, so we temporarily remember
  // which player should receive the carried-forward selections.
  int? _pendingWinnerIndex;

  late final ScrollController _headerHorizontalController;
  late final ScrollController _bodyHorizontalController;
  late final ScrollController _leftVerticalController;
  late final ScrollController _rightVerticalController;

  bool _syncingHorizontal = false;
  bool _syncingVertical = false;

  Iterable<ScoringRule> get _allRules => [
        ...ScoringRules.baseRules,
        ...ScoringRules.bonusRules,
      ];

  @override
  void initState() {
    super.initState();

    _headerHorizontalController = ScrollController();
    _bodyHorizontalController = ScrollController();
    _leftVerticalController = ScrollController();
    _rightVerticalController = ScrollController();

    _headerHorizontalController.addListener(_syncHeaderScroll);
    _bodyHorizontalController.addListener(_syncBodyHorizontalScroll);
    _leftVerticalController.addListener(_syncLeftVerticalScroll);
    _rightVerticalController.addListener(_syncRightVerticalScroll);

    _initialize();

    // Restore the most recent winner's complete selection when
    // returning to the score screen through Resume Game.
    final game = GameService.instance.currentGame;

    if (game != null &&
        widget.winnerIndex >= 0 &&
        game.lastWinningSelections.isNotEmpty) {
      _initialize(
        populatePlayerIndex: widget.winnerIndex,
        selections: game.lastWinningSelections,
      );
    }

    for (final rule in ScoringRules.baseRules) {
      _pointControllers[rule.name] = TextEditingController(
        text: ScoringValueService.instance.getPoints(rule.name).toString(),
      );
    }
  }

  @override
  void dispose() {
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    _leftVerticalController.dispose();
    _rightVerticalController.dispose();

    for (final controller in _pointControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _initialize({
    int? populatePlayerIndex,
    Map<String, int>? selections,
  }) {
    _quantities
      ..clear()
      ..addEntries(
        _allRules.map(
          (rule) => MapEntry(
            rule.name,
            List<int>.filled(widget.playerNames.length, 0),
          ),
        ),
      );

    if (populatePlayerIndex == null ||
        selections == null ||
        populatePlayerIndex < 0 ||
        populatePlayerIndex >= widget.playerNames.length ||
        widget.playerNames[populatePlayerIndex].trim().isEmpty) {
      return;
    }

    for (final rule in _allRules) {
      if ((selections[rule.name] ?? 0) > 0) {
        _quantities[rule.name]![populatePlayerIndex] = 1;
      }
    }
  }

  void _rememberCurrentWinnerSelections() {
    final index = widget.winnerIndex;

    if (index < 0 || index >= widget.playerNames.length) {
      return;
    }

    if (widget.playerNames[index].trim().isEmpty) {
      return;
    }

    final remembered = <String, int>{};

    for (final rule in _allRules) {
      if ((_quantities[rule.name]?[index] ?? 0) > 0) {
        remembered[rule.name] = 1;
      }
    }

    _carryForwardSelections = remembered;
  }

  void _syncHeaderScroll() {
    if (_syncingHorizontal || !_bodyHorizontalController.hasClients) {
      return;
    }

    _syncingHorizontal = true;
    _bodyHorizontalController.jumpTo(
      _headerHorizontalController.offset,
    );
    _syncingHorizontal = false;
  }

  void _syncBodyHorizontalScroll() {
    if (_syncingHorizontal ||
        !_headerHorizontalController.hasClients) {
      return;
    }

    _syncingHorizontal = true;
    _headerHorizontalController.jumpTo(
      _bodyHorizontalController.offset,
    );
    _syncingHorizontal = false;
  }

  void _syncLeftVerticalScroll() {
    if (_syncingVertical || !_rightVerticalController.hasClients) {
      return;
    }

    _syncingVertical = true;
    _rightVerticalController.jumpTo(
      _leftVerticalController.offset,
    );
    _syncingVertical = false;
  }

  void _syncRightVerticalScroll() {
    if (_syncingVertical || !_leftVerticalController.hasClients) {
      return;
    }

    _syncingVertical = true;
    _leftVerticalController.jumpTo(
      _rightVerticalController.offset,
    );
    _syncingVertical = false;
  }

  Future<void> _savePointsValue(String ruleName) async {
    final controller = _pointControllers[ruleName]!;
    final value = int.tryParse(controller.text.trim());

    if (value == null) {
      controller.text = ScoringValueService.instance
          .getPoints(ruleName)
          .toString();
      return;
    }

    await ScoringValueService.instance.setPoints(
      ruleName,
      value,
    );
  }

  Future<void> resetPointValues() async {
    await ScoringValueService.instance.resetToDefaults();

    for (final rule in ScoringRules.baseRules) {
      _pointControllers[rule.name]!.text = ScoringValueService
          .instance
          .getPoints(rule.name)
          .toString();
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Clears the current round's selections while preserving the complete
  /// winner selection for the next winner.
  void prepareNextRound() {
    clearAll();
  }

  /// Clears the visible selections while preserving the most recent
  /// winner's complete selection so it can be reused by the next winner.
  ///
  /// This method is also called by ScoreScreen after SAVE ROUND and when
  /// the winner changes. In both cases the previous winner's Base Point
  /// and Mahjong outcome are carried forward automatically.
  void clearAll() {
    if (_pendingWinnerIndex != null) {
      final targetIndex = _pendingWinnerIndex!;
      final selections = Map<String, int>.from(_carryForwardSelections);
      _pendingWinnerIndex = null;

      setState(() {
        _initialize(
          populatePlayerIndex: targetIndex,
          selections: selections,
        );
      });
    } else {
      // SAVE ROUND calls clearAll() while the current winner is still
      // selected. Capture that winner's selections before clearing them.
      _rememberCurrentWinnerSelections();

      final targetIndex = widget.winnerIndex;
      final selections = Map<String, int>.from(_carryForwardSelections);

      setState(() {
        _initialize(
          populatePlayerIndex: targetIndex,
          selections: selections,
        );
      });
    }

    widget.onChanged(_quantities);
  }

  void _toggleRule(
    ScoringRule rule,
    int playerIndex,
    bool value,
  ) {
    setState(() {
      _quantities[rule.name]![playerIndex] = value ? 1 : 0;

      if (value) {
        final group = rule.type == ScoringType.base
            ? ScoringRules.baseRules
            : ScoringRules.bonusRules;

        // Only one Base Point pattern and only one Mahjong outcome
        // may be selected for a winner.
        for (final other in group) {
          if (other.name != rule.name) {
            _quantities[other.name]![playerIndex] = 0;
          }
        }
      }
    });

    widget.onChanged(_quantities);
  }

  void _selectWinner(int index) {
    // An empty player name means the player is inactive.
    if (widget.playerNames[index].trim().isEmpty) {
      return;
    }

    if (widget.winnerIndex == index) {
      return;
    }

    // Capture the CURRENT winner's complete selection before the parent
    // changes winnerIndex. This is the state that must be copied to the
    // newly selected winner.
    _rememberCurrentWinnerSelections();
    _pendingWinnerIndex = index;

    // Do not clear here. ScoreScreen changes winnerIndex and then calls
    // clearAll(); clearAll() will apply _carryForwardSelections to the
    // new winner.
    widget.onWinnerChanged(index);
  }

  Widget _sectionTitle(String title) => Container(
        height: _sectionTitleHeight,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _leftRow(ScoringRule rule) {
    final label = rule.name == 'Self-draw Chip Mahjong'
        ? 'Self-draw Chip'
        : rule.name == 'Discarded Chip Mahjong'
            ? 'Discarded Chip'
            : rule.name;

    final fontSize = label.length > 20
        ? 10.0
        : label.length > 12
            ? 12.0
            : 14.0;

    return SizedBox(

      height: _rowHeight,
      child: Row(
        children: [
          SizedBox(
            width: _ruleNameWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: _pointsWidth,
            child: rule.type == ScoringType.base
                ? Center(
                    child: TextField(
                      controller: _pointControllers[rule.name],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) =>
                          _savePointsValue(rule.name),
                      onEditingComplete: () =>
                          _savePointsValue(rule.name),
                    ),
                  )
                : Center(
                    child: Text(
                      rule.name == 'Self-draw Chip Mahjong'
                          ? '摸'
                          : '胡',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            rule.name == 'Self-draw Chip Mahjong'
                                ? Colors.green[800]
                                : Colors.red[800],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _rightRow(ScoringRule rule) => SizedBox(
        height: _rowHeight,
        child: Row(
          children: List.generate(
            widget.playerNames.length,
            (index) {
              final enabled = index == widget.winnerIndex;
              final playerTheme = PlayerColors.player(index);

              return SizedBox(
                width: _playerColumnWidth,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: enabled
                          ? playerTheme.background.withValues(
                              alpha: 0.35,
                            )
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Transform.scale(
                      scale: 1.3,
                      child: Checkbox.adaptive(
                        value:
                            _quantities[rule.name]![index] > 0,
                        shape: const CircleBorder(),
                        side: BorderSide(
                          color: playerTheme.accent,
                          width: 1.6,
                        ),
                        activeColor: playerTheme.accent,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        onChanged: enabled
                            ? (value) => _toggleRule(
                                  rule,
                                  index,
                                  value ?? false,
                                )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget _specialOutcomeLeftBackground() {
    final top =
        _sectionTitleHeight +
        (ScoringRules.baseRules.length * _rowHeight) +
        12;

    return Positioned(
      left: 0,
      top: top,
      width: _ruleNameWidth + _pointsWidth,
      height: _sectionTitleHeight +
    (ScoringRules.bonusRules.length * _rowHeight),
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.25),
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              bottom: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              left: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_specialBoxRadius),
              bottomLeft: Radius.circular(_specialBoxRadius),
            ),
          ),
        ),
      ),
    );
  }

  Widget _specialOutcomeRightBackground() {
    final top =
        _sectionTitleHeight +
        (ScoringRules.baseRules.length * _rowHeight) +
        12;

    final width =
        (_playerColumnWidth * widget.playerNames.length) -
        _specialBoxRightTrim;

    return Positioned(
      left: 0,
      top: top,
      width: width,
      height: _sectionTitleHeight +
    (ScoringRules.bonusRules.length * _rowHeight),
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.25),
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              bottom: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              right: BorderSide(
                color: Colors.grey.withValues(alpha: 0.25),
              ),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(_specialBoxRadius),
              bottomRight: Radius.circular(_specialBoxRadius),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _leftBody() => [
    _sectionTitle('BASE POINTS'),
    ...ScoringRules.baseRules.map(_leftRow),
    const SizedBox(height: 6),
    _sectionTitle('MAHJONG OUTCOME'),
    ...ScoringRules.bonusRules.map(_leftRow),
  ];

  List<Widget> _rightBody() => [
    const SizedBox(height: _sectionTitleHeight),
    ...ScoringRules.baseRules.map(_rightRow),
    const SizedBox(height: 6),
    const SizedBox(height: _sectionTitleHeight),
    ...ScoringRules.bonusRules.map(_rightRow),
  ];

  @override
  Widget build(BuildContext context) {
    final game = GameService.instance.currentGame!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _ruleNameWidth + _pointsWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Round ${game.round}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _headerHorizontalController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    game.players.length,
                    (index) {
                      final player = game.players[index];

                      return SizedBox(
                        width: _playerColumnWidth,
                        child: PlayerHeader(
                          key: ValueKey(
                            '${player.id}-${player.wind}',
                          ),
                          playerIndex: index,
                          playerName: player.name,
                          runningTotal: player.score,
                          wind: player.wind,
                          isWinner: widget.winnerIndex == index,
                          onWinnerTapped: () =>
                              _selectWinner(index),
                          onNameChanged: (name) {
                            setState(() => player.name = name);
                            widget.onPlayerNameChanged(
                              index,
                              name,
                            );
                            GameService.instance
                                .saveCurrentGame();
                          },
                          canSelectEast: game.round == 1,
                          onEastTapped: () async {
                            if (game.round != 1) return;

                            setState(
                              () => game.setStartingEast(index),
                            );

                            await GameService.instance
                                .saveCurrentGame();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 4),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _ruleNameWidth + _pointsWidth,
                child: SingleChildScrollView(
                  controller: _leftVerticalController,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: _leftBody(),
                      ),
                      _specialOutcomeLeftBackground(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _bodyHorizontalController,
                  child: SingleChildScrollView(
                    controller: _bodyHorizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: _playerColumnWidth *
                          widget.playerNames.length,
                      child: SingleChildScrollView(
                        controller: _rightVerticalController,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: _rightBody(),
                            ),
                            _specialOutcomeRightBackground(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../services/scoring_value_service.dart';
import '../theme/player_colors.dart';
import 'player_header.dart';
import 'quantity_control.dart';

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

  static const double _sectionTitleHeight = 34;
  static const double _rowHeight = 32;
  static const double _descriptionDialogWidth =
      _ruleNameWidth + _pointsWidth + (_playerColumnWidth * 2);

  // Visual-only settings for the special outcome box.
  static const double _specialBoxRightTrim = 4;
  static const double _specialBoxRadius = 6;

  final Map<String, List<int>> _quantities = {};
  final Map<String, TextEditingController> _pointControllers = {};

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

  void _initialize() {
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
  }

  void _syncHeaderScroll() {
    if (_syncingHorizontal || !_bodyHorizontalController.hasClients) {
      return;
    }

    _syncingHorizontal = true;
    _bodyHorizontalController.jumpTo(_headerHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _syncBodyHorizontalScroll() {
    if (_syncingHorizontal || !_headerHorizontalController.hasClients) {
      return;
    }

    _syncingHorizontal = true;
    _headerHorizontalController.jumpTo(_bodyHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _syncLeftVerticalScroll() {
    if (_syncingVertical || !_rightVerticalController.hasClients) {
      return;
    }

    _syncingVertical = true;
    _rightVerticalController.jumpTo(_leftVerticalController.offset);
    _syncingVertical = false;
  }

  void _syncRightVerticalScroll() {
    if (_syncingVertical || !_leftVerticalController.hasClients) {
      return;
    }

    _syncingVertical = true;
    _leftVerticalController.jumpTo(_rightVerticalController.offset);
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

    await ScoringValueService.instance.setPoints(ruleName, value);
  }

  Future<void> resetPointValues() async {
    await ScoringValueService.instance.resetToDefaults();

    for (final rule in ScoringRules.baseRules) {
      _pointControllers[rule.name]!.text = ScoringValueService.instance
          .getPoints(rule.name)
          .toString();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void resetForNewRound() {
    setState(_initialize);
    widget.onChanged(_quantities);
  }

  static const Set<String> _standalonePatternNames = {
    'Full Flush',
    'Seven Pairs',
    'Nine Gates',
  };

  bool _isStandalonePattern(ScoringRule rule) =>
      _standalonePatternNames.contains(rule.name);

  int _quantityFor(String ruleName, int playerIndex) =>
      _quantities[ruleName]?[playerIndex] ?? 0;

  int _displayedBonusPoints(ScoringRule rule) {
    if (rule.name != 'Discarded Chip Mahjong') return rule.points;

    final activePlayerCount = widget.playerNames
        .where((name) => name.trim().isNotEmpty)
        .length;
    return activePlayerCount > 1 ? rule.points * (activePlayerCount - 1) : 0;
  }

  String _displayedBonusValue(ScoringRule rule) {
    if (rule.name != 'Discarded Chip Mahjong') return '${rule.points}';

    final activePlayerCount = widget.playerNames
        .where((name) => name.trim().isNotEmpty)
        .length;
    return '${rule.points}x${activePlayerCount > 1 ? activePlayerCount - 1 : 0}';
  }

  bool _hasStandalonePattern(int playerIndex) => ScoringRules.baseRules.any(
    (rule) =>
        _isStandalonePattern(rule) && _quantityFor(rule.name, playerIndex) > 0,
  );

  bool _hasOtherBaseSelection(ScoringRule rule, int playerIndex) =>
      ScoringRules.baseRules.any(
        (other) =>
            other.name != rule.name &&
            _quantityFor(other.name, playerIndex) > 0,
      );

  bool _canSelectBaseRule(ScoringRule rule, int playerIndex) {
    if (_isStandalonePattern(rule)) {
      return !_hasOtherBaseSelection(rule, playerIndex);
    }

    return !_hasStandalonePattern(playerIndex);
  }

  bool _isLowerBasePattern(ScoringRule rule) {
    final ruleIndex = ScoringRules.baseRules.indexOf(rule);
    return ruleIndex >= 0 && ruleIndex < 5;
  }

  bool _isPurePatternSelected(int playerIndex) =>
      _quantityFor('Pure Triple Chow', playerIndex) > 0 ||
      _quantityFor('Pure Straight', playerIndex) > 0;

  bool _hasOtherPurePattern(ScoringRule rule, int playerIndex) =>
      ScoringRules.baseRules.any(
        (other) =>
            _isRestrictedByPurePattern(other) &&
            other.name != rule.name &&
            _quantityFor(other.name, playerIndex) > 0,
      );

  int _selectedBaseQuantity(int playerIndex) => ScoringRules.baseRules
      .where((rule) => rule.countsTowardCombinationLimit)
      .fold(
        0,
        (total, rule) => total + (_quantities[rule.name]?[playerIndex] ?? 0),
      );

  int _selectedLowerQuantity(int playerIndex) => ScoringRules.baseRules
      .where(_isLowerBasePattern)
      .fold(0, (total, rule) => total + _quantityFor(rule.name, playerIndex));

  int _maxSelectableQuantity(ScoringRule rule, int playerIndex) {
    if (!_canSelectBaseRule(rule, playerIndex)) return 0;
    if (_isStandalonePattern(rule)) return rule.maxQuantity;

    final otherQuantity = ScoringRules.baseRules
        .where(
          (other) =>
              other.countsTowardCombinationLimit && other.name != rule.name,
        )
        .fold<int>(
          0,
          (total, other) => total + _quantityFor(other.name, playerIndex),
        );

    var remaining = ScoringRules.maxCombinedQuantity - otherQuantity;
    final doubleSequenceQuantity = _quantityFor('Double Sequence', playerIndex);
    final lowerQuantity = _selectedLowerQuantity(playerIndex);
    final purePatternSelected = _isPurePatternSelected(playerIndex);

    if (_isLowerBasePattern(rule)) {
      final lowerPatternLimit = doubleSequenceQuantity == 2
          ? 0
          : purePatternSelected
          ? 1
          : doubleSequenceQuantity == 1
          ? 2
          : ScoringRules.maxCombinedQuantity;
      final remainingLowerQuantity =
          lowerPatternLimit -
          (lowerQuantity - _quantityFor(rule.name, playerIndex));
      if (remainingLowerQuantity < remaining) {
        remaining = remainingLowerQuantity;
      }
    } else if (rule.name == 'Double Sequence') {
      if (purePatternSelected) return 0;
      const lowerPatternLimit = 2;
      if (lowerQuantity > lowerPatternLimit) return 0;
      if (lowerQuantity > 0) {
        remaining = remaining < 1 ? remaining : 1;
      }
    }

    if (remaining <= 0) return 0;
    return remaining < rule.maxQuantity ? remaining : rule.maxQuantity;
  }

  bool _canToggleBasePattern(ScoringRule rule, int playerIndex) {
    if (_quantityFor(rule.name, playerIndex) > 0) return true;
    if (!_canSelectBaseRule(rule, playerIndex)) return false;
    if (_isRestrictedByPurePattern(rule) &&
        _hasOtherPurePattern(rule, playerIndex)) {
      return false;
    }
    if (_isRestrictedByPurePattern(rule) &&
        _quantityFor('Double Sequence', playerIndex) > 0) {
      return false;
    }
    if (rule.countsTowardCombinationLimit &&
        _selectedBaseQuantity(playerIndex) >=
            ScoringRules.maxCombinedQuantity) {
      return false;
    }
    return !_isRestrictedByPurePattern(rule) ||
        _selectedLowerQuantity(playerIndex) <= 1;
  }

  void _setBaseQuantity(ScoringRule rule, int playerIndex, int quantity) {
    if (quantity > _maxSelectableQuantity(rule, playerIndex)) {
      _showBaseSelectionLimitMessage();
      return;
    }

    setState(() {
      _quantities[rule.name]![playerIndex] = quantity;
    });

    widget.onChanged(_quantities);
  }

  void _toggleBasePattern(ScoringRule rule, int playerIndex, bool value) {
    if (value) {
      final lowerQuantity = _selectedLowerQuantity(playerIndex);
      if (!_canSelectBaseRule(rule, playerIndex) ||
          (_isRestrictedByPurePattern(rule) &&
              _hasOtherPurePattern(rule, playerIndex)) ||
          (_isRestrictedByPurePattern(rule) &&
              _quantityFor('Double Sequence', playerIndex) > 0) ||
          (rule.countsTowardCombinationLimit &&
              _selectedBaseQuantity(playerIndex) + 1 >
                  ScoringRules.maxCombinedQuantity) ||
          (_isRestrictedByPurePattern(rule) && lowerQuantity > 1)) {
        _showBaseSelectionLimitMessage();
        return;
      }
    }

    setState(() {
      _quantities[rule.name]![playerIndex] = value ? 1 : 0;
    });

    widget.onChanged(_quantities);
  }

  bool _isRestrictedByPurePattern(ScoringRule rule) =>
      rule.name == 'Pure Triple Chow' || rule.name == 'Pure Straight';

  void _showBaseSelectionLimitMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'This combination exceeds the allowed base-pattern quantity.',
          ),
        ),
      );
  }

  void _toggleOutcome(ScoringRule rule, int playerIndex, bool value) {
    setState(() {
      _quantities[rule.name]![playerIndex] = value ? 1 : 0;

      if (value) {
        for (final other in ScoringRules.bonusRules) {
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

    widget.onWinnerChanged(index);
  }

  Widget _sectionTitle(String title, String description) => SizedBox(
    height: _sectionTitleHeight,
    width: double.infinity,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDescription(title, description),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _showDescription(String title, String description) =>
      showDialog<void>(
        context: context,
        builder: (context) {
          final availableWidth = MediaQuery.sizeOf(context).width - 32;
          final dialogWidth = math.min(_descriptionDialogWidth, availableWidth);
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            constraints: BoxConstraints(maxWidth: dialogWidth),
            title: Text(title),
            content: SizedBox(width: dialogWidth, child: Text(description)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );

  String _descriptionForRule(ScoringRule rule) {
    if (rule.name != 'Discarded Chip Mahjong') {
      return rule.description ?? rule.name;
    }

    final activePlayerCount = widget.playerNames
        .where((name) => name.trim().isNotEmpty)
        .length;
    return 'Each opponent pays ${rule.points} × '
        '($activePlayerCount active players − 1) '
        '= ${_displayedBonusPoints(rule)} points.';
  }

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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showDescription(label, _descriptionForRule(rule)),
                child: Container(
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
            ),
          ),
          SizedBox(
            width: _pointsWidth,
            child: rule.type == ScoringType.base
                ? Center(
                    child: TextField(
                      controller: _pointControllers[rule.name],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _savePointsValue(rule.name),
                      onEditingComplete: () => _savePointsValue(rule.name),
                    ),
                  )
                : Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _showDescription(label, _descriptionForRule(rule)),
                        child: Text(
                          _displayedBonusValue(rule),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rule.name == 'Self-draw Chip Mahjong'
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
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
      children: List.generate(widget.playerNames.length, (index) {
        final columnActive = index == widget.winnerIndex;
        final playerTheme = PlayerColors.player(index);
        final ruleSelected = _quantityFor(rule.name, index) > 0;
        final baseRuleEnabled =
            rule.type == ScoringType.base &&
            (rule.maxQuantity > 1
                ? _maxSelectableQuantity(rule, index) > 0
                : _canToggleBasePattern(rule, index));
        final enabled =
            columnActive && (rule.type == ScoringType.bonus || baseRuleEnabled);

        return SizedBox(
          width: _playerColumnWidth,
          child: Opacity(
            opacity: columnActive ? 1 : 0.4,
            child: Container(
              width: _playerColumnWidth,
              height: _rowHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: columnActive
                    ? playerTheme.background.withValues(alpha: 0.55)
                    : Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: columnActive
                      ? playerTheme.background.withValues(alpha: 0.35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: rule.type == ScoringType.base && rule.maxQuantity > 1
                    ? QuantityControl(
                        value: _quantities[rule.name]![index],
                        maxValue: _maxSelectableQuantity(rule, index),
                        enabled: enabled,
                        playerColor: playerTheme.accent,
                        compact: true,
                        onChanged: (quantity) =>
                            _setBaseQuantity(rule, index, quantity),
                      )
                    : Transform.scale(
                        scale: 1.3,
                        child: Checkbox.adaptive(
                          value: ruleSelected,
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: enabled
                                ? playerTheme.accent
                                : Colors.grey.shade400,
                            width: 1.6,
                          ),
                          activeColor: enabled
                              ? playerTheme.accent
                              : Colors.grey.shade400,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: enabled
                              ? (value) => rule.type == ScoringType.base
                                    ? _toggleBasePattern(
                                        rule,
                                        index,
                                        value ?? false,
                                      )
                                    : _toggleOutcome(
                                        rule,
                                        index,
                                        value ?? false,
                                      )
                              : null,
                          key: rule.name == 'Self-draw Chip Mahjong'
                              ? ValueKey('outcome-self-draw-$index')
                              : rule.name == 'Discarded Chip Mahjong'
                              ? ValueKey('outcome-discarded-$index')
                              : null,
                        ),
                      ),
              ),
            ),
          ),
        );
      }),
    ),
  );

  Widget _specialOutcomeLeftBackground() {
    final top =
        _sectionTitleHeight + (ScoringRules.baseRules.length * _rowHeight) + 12;

    return Positioned(
      left: 0,
      top: top,
      width: _ruleNameWidth + _pointsWidth,
      height:
          _sectionTitleHeight + (ScoringRules.bonusRules.length * _rowHeight),
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.25),
            border: Border(
              top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
              bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
              left: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
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
        _sectionTitleHeight + (ScoringRules.baseRules.length * _rowHeight) + 12;

    final width =
        (_playerColumnWidth * widget.playerNames.length) - _specialBoxRightTrim;

    return Positioned(
      left: 0,
      top: top,
      width: width,
      height:
          _sectionTitleHeight + (ScoringRules.bonusRules.length * _rowHeight),
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.25),
            border: Border(
              top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
              bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
              right: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
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
    _sectionTitle(
      'BASE POINTS',
      'Select the patterns that apply to the winning hand. '
          'Their points are multiplied by the selected quantities.',
    ),
    ...ScoringRules.baseRules.map(_leftRow),
    const SizedBox(height: 6),
    _sectionTitle(
      'MAHJONG OUTCOME',
      'Choose how Mahjong was won: self-draw or from another player’s discard. '
          'The bonus is added to the winner’s score and paid by the other '
          'active players.',
    ),
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
                  children: List.generate(game.players.length, (index) {
                    final player = game.players[index];

                    return SizedBox(
                      width: _playerColumnWidth,
                      child: PlayerHeader(
                        key: ValueKey('${player.id}-${player.wind}'),
                        playerIndex: index,
                        playerName: player.name,
                        runningTotal: player.score,
                        wind: player.wind,
                        isWinner: widget.winnerIndex == index,
                        awaitingWinnerSelection:
                            widget.winnerIndex < 0 &&
                            player.name.trim().isNotEmpty,
                        onWinnerTapped: () => _selectWinner(index),
                        onNameChanged: (name) {
                          setState(() => player.name = name);
                          widget.onPlayerNameChanged(index, name);
                          GameService.instance.saveCurrentGame();
                        },
                        canSelectEast: game.round == 1,
                        onEastTapped: () async {
                          if (game.round != 1) return;

                          setState(() => game.setStartingEast(index));

                          await GameService.instance.saveCurrentGame();
                        },
                      ),
                    );
                  }),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: _playerColumnWidth * widget.playerNames.length,
                      child: SingleChildScrollView(
                        controller: _rightVerticalController,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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

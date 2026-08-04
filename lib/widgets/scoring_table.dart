import 'player_header.dart';
import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../theme/player_colors.dart';
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
  State<ScoringTable> createState() =>
      ScoringTableState();
}


class ScoringTableState extends State<ScoringTable> {

  static const double _ruleNameWidth = 140;
  static const double _pointsWidth = 34;
  static const double _playerColumnWidth = 100;

  final Map<String, List<int>> _quantities = {};
  late final ScrollController _headerHorizontalController;
  late final ScrollController _bodyHorizontalController;
  late final ScrollController _leftVerticalController;
  late final ScrollController _rightVerticalController;

  bool _isSyncingHorizontal = false;
  bool _isSyncingVertical = false;

  static const double _sectionTitleHeight = 34;

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
  }

  void _syncHeaderScroll() {
    if (_isSyncingHorizontal) return;
    _isSyncingHorizontal = true;
    _bodyHorizontalController.jumpTo(
      _headerHorizontalController.offset,
    );
    _isSyncingHorizontal = false;
  }

  void _syncBodyHorizontalScroll() {
    if (_isSyncingHorizontal) return;
    _isSyncingHorizontal = true;
    _headerHorizontalController.jumpTo(
      _bodyHorizontalController.offset,
    );
    _isSyncingHorizontal = false;
  }

  void _syncLeftVerticalScroll() {
    if (_isSyncingVertical) return;
    _isSyncingVertical = true;
    _rightVerticalController.jumpTo(
      _leftVerticalController.offset,
    );
    _isSyncingVertical = false;
  }

  void _syncRightVerticalScroll() {
    if (_isSyncingVertical) return;
    _isSyncingVertical = true;
    _leftVerticalController.jumpTo(
      _rightVerticalController.offset,
    );
    _isSyncingVertical = false;
  }

  @override
  void dispose() {
    _headerHorizontalController.removeListener(_syncHeaderScroll);
    _bodyHorizontalController.removeListener(_syncBodyHorizontalScroll);
    _leftVerticalController.removeListener(_syncLeftVerticalScroll);
    _rightVerticalController.removeListener(_syncRightVerticalScroll);
    _headerHorizontalController.dispose();
    _bodyHorizontalController.dispose();
    _leftVerticalController.dispose();
    _rightVerticalController.dispose();
    super.dispose();
  }

  void _initialize() {

    _quantities.clear();

    for (final rule in [
      ...ScoringRules.baseRules,
      ...ScoringRules.bonusRules,
    ]) {

      _quantities[rule.name] =
          List<int>.filled(
            widget.playerNames.length,
            0,
          );
    }
  }



  void clearAll() {

    setState(() {
      _initialize();
    });

    widget.onChanged(_quantities);
  }



  bool _isBonusRule(
    ScoringRule rule,
  ) {

    return rule.type ==
        ScoringType.bonus;

  }


  bool _isToggleBonus(
    String name,
  ) {

    return name ==
            '6 Consecutive # (1 suit)' ||
        name ==
            '2X 6 Consecutive # (1 suit / 6 tiles)' ||
        name ==
            '4 Sets of Pong (12 chips)' ||
        name ==
            'Self-draw Chip Mahjong' ||
        name ==
            'Discarded Chip Mahjong';

  }







  void _setQuantity(
    String ruleName,
    int playerIndex,
    int newValue,
    int maxValue,
  ) {
    final values = _quantities[ruleName]!;
    final currentValue = values[playerIndex];

    if (newValue < 0 || newValue > maxValue || newValue == currentValue) {
      return;
    }

    const meldRules = [
      'Chow',
      'Pong',
      'Pong (Wind/Dragon)',
      'Kong',
      'Kong (Wind/Dragon)',
    ];

    if (meldRules.contains(ruleName)) {
      int meldTotal = 0;
      for (final rule in meldRules) {
        meldTotal += _quantities[rule]![playerIndex];
      }

      final available = 4 - (meldTotal - currentValue);
      if (newValue > currentValue && newValue > currentValue + available) {
        if (available <= 0) {
          return;
        }
        newValue = currentValue + available;
      }
    }

    setState(() {
      values[playerIndex] = newValue;
    });

    widget.onChanged(
      _quantities,
    );
  }



  void _toggleBonus(
    String ruleName,
    int playerIndex,
    bool value,
  ) {

    setState(() {

      _quantities[ruleName]![playerIndex] =
          value ? 1 : 0;

      if (value) {

        const consecutiveGroup = [
          '6 Consecutive # (1 suit)',
          '2X 6 Consecutive # (1 suit / 6 tiles)',
          '4 Sets of Pong (12 chips)',
        ];

        if (consecutiveGroup.contains(ruleName)) {

          for (final rule in consecutiveGroup) {

            if (rule != ruleName) {
              _quantities[rule]![playerIndex] = 0;
            }

          }

        }

        const mahjongGroup = [
          'Self-draw Chip Mahjong',
          'Discarded Chip Mahjong',
        ];

        if (mahjongGroup.contains(ruleName)) {

          for (final rule in mahjongGroup) {

            if (rule != ruleName) {
              _quantities[rule]![playerIndex] = 0;
            }

          }

        }

      }

    });

    widget.onChanged(_quantities);

  }

  void _toggleCheckboxBonus(
    String ruleName,
    int playerIndex,
    bool? value,
  ) {
    setState(() {
      _quantities[ruleName]![playerIndex] =
          value == true ? 1 : 0;
    });

    widget.onChanged(
      _quantities,
    );
  }


  String _displayRuleName(
    String ruleName,
  ) {
    switch (ruleName) {
      case 'Dragon/Wind Pair':
        return 'Honor Pair';
      case 'Pong (Wind/Dragon)':
        return 'Honor Pong';
      case 'Kong (Wind/Dragon)':
        return 'Honor Kong';
      default:
        return ruleName;
    }
  }


  void _selectWinner(
    int index,
  ) {

    if (widget.winnerIndex != index) {

      clearAll();

      widget.onWinnerChanged(
        index,
      );
    }
  }




  Widget _buildSectionTitle(
    String title,
  ) {
    return Container(
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
  }

  Widget _buildLeftRow(
    ScoringRule rule,
  ) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          SizedBox(
            width: _ruleNameWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _displayRuleName(rule.name),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: _pointsWidth,
            child: Center(
              child: Text(
                rule.points.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightRow(
    ScoringRule rule,
  ) {
    final isBonus = _isBonusRule(rule);
    final isToggle = _isToggleBonus(rule.name);

    return SizedBox(
      height: 48,
      child: Row(
        children: List.generate(
          widget.playerNames.length,
          (index) {
            final enabled =
                !isBonus || index == widget.winnerIndex;

            if (isToggle) {
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
                    child: Switch(
                      value: _quantities[rule.name]![index] > 0,
                      activeThumbColor: playerTheme.accent,
                      onChanged: enabled
                          ? (value) {
                              _toggleBonus(
                                rule.name,
                                index,
                                value,
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              );
            }

            if (isBonus) {
              return SizedBox(
                width: _playerColumnWidth,
                child: Center(
                  child: Checkbox.adaptive(
                    key: ValueKey(
                      '${rule.name}-${widget.playerNames[index]}',
                    ),
                    value: _quantities[rule.name]![index] == 1,
                    onChanged: enabled
                        ? (checked) {
                            _toggleCheckboxBonus(
                              rule.name,
                              index,
                              checked ?? false,
                            );
                          }
                        : null,
                  ),
                ),
              );
            }

            return SizedBox(
              width: _playerColumnWidth,
              child: Center(
                child: QuantityControl(
                  value: _quantities[rule.name]![index],
                  maxValue: rule.maxQuantity,
                  enabled: enabled,
                  playerColor: PlayerColors.player(index).accent,
                  onChanged: (newValue) {
                    if (!enabled) return;
                    _setQuantity(
                      rule.name,
                      index,
                      newValue,
                      rule.maxQuantity,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  List<Widget> _buildLeftBody() {
    return [
      _buildSectionTitle('BASE'),
      ...ScoringRules.baseRules.map(_buildLeftRow),
      const SizedBox(height: 4),
      _buildSectionTitle('BONUS'),
      ...ScoringRules.bonusRules.map(_buildLeftRow),
    ];
  }

  List<Widget> _buildRightBody() {
    return [
      const SizedBox(height: _sectionTitleHeight),
      ...ScoringRules.baseRules.map(_buildRightRow),
      const SizedBox(height: 4),
      const SizedBox(height: _sectionTitleHeight),
      ...ScoringRules.bonusRules.map(_buildRightRow),
    ];
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final game = GameService.instance.currentGame!;
    final playerCount = widget.playerNames.length;
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
                    const SizedBox(height: 2),
                    Text(
                      'Honor: Winds and Dragons',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
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
                          onWinnerTapped: () {
                            _selectWinner(index);
                          },
                          onNameChanged: (newName) {
                            setState(() {
                              player.name = newName;
                            });
                            widget.onPlayerNameChanged(index, newName);
                            GameService.instance.saveCurrentGame();
                          },
                          canSelectEast: game.round == 1,
                          onEastTapped: () async {
                            if (game.round != 1) return;
                            setState(() {
                              game.setStartingEast(index);
                            });
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildLeftBody(),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _bodyHorizontalController,
                    thumbVisibility: true,
                    thickness: 8,
                    radius: Radius.circular(4),
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: SingleChildScrollView(
                      controller: _bodyHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: playerCount * _playerColumnWidth,
                        child: SingleChildScrollView(
                          controller: _rightVerticalController,
                          child: Column(
                            children: _buildRightBody(),
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


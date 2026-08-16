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
  static const double _ruleNameWidth = 128;
  static const double _pointsWidth = 34;
  static const double _playerColumnWidth = 82;
  static const double scoreGridWidth =
      _ruleNameWidth + _pointsWidth + (_playerColumnWidth * 4);
  static const double titleGridWidth =
      _ruleNameWidth + _pointsWidth + (_playerColumnWidth * 3);
  static const double _sectionTitleHeight = 24;

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
    if (_syncingHorizontal || !_bodyHorizontalController.hasClients) return;
    _syncingHorizontal = true;
    _bodyHorizontalController.jumpTo(_headerHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _syncBodyHorizontalScroll() {
    if (_syncingHorizontal || !_headerHorizontalController.hasClients) return;
    _syncingHorizontal = true;
    _headerHorizontalController.jumpTo(_bodyHorizontalController.offset);
    _syncingHorizontal = false;
  }

  void _syncLeftVerticalScroll() {
    if (_syncingVertical || !_rightVerticalController.hasClients) return;
    _syncingVertical = true;
    _rightVerticalController.jumpTo(_leftVerticalController.offset);
    _syncingVertical = false;
  }

  void _syncRightVerticalScroll() {
    if (_syncingVertical || !_leftVerticalController.hasClients) return;
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
    if (mounted) setState(() {});
  }

  void clearAll() {
    setState(_initialize);
    widget.onChanged(_quantities);
  }

  void _toggleRule(ScoringRule rule, int playerIndex, bool value) {
    setState(() {
      _quantities[rule.name]![playerIndex] = value ? 1 : 0;
      if (value) {
        final group = rule.type == ScoringType.base
            ? ScoringRules.baseRules
            : ScoringRules.bonusRules;
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
    if (widget.winnerIndex == index) return;
    clearAll();
    widget.onWinnerChanged(index);
  }

  Widget _sectionTitle(String title) => Container(
    height: _sectionTitleHeight,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
  );

  Widget _leftRow(ScoringRule rule) {
    final label = rule.name;
    final fontSize = label.length > 24
        ? 10.0
        : label.length > 18
        ? 12.0
        : 14.0;
    return SizedBox(
      height: 34,
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
                    child: Text(
                      rule.name == 'Self-draw Chip Mahjong' ? '摸' : '胡',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: rule.name == 'Self-draw Chip Mahjong'
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
    height: 34,
    child: Row(
      children: List.generate(widget.playerNames.length, (index) {
        final enabled = index == widget.winnerIndex;
        final playerTheme = PlayerColors.player(index);
        return SizedBox(
          width: _playerColumnWidth,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: enabled
                    ? playerTheme.background.withValues(alpha: 0.35)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Transform.scale(
                scale: 1.3,
                child: Checkbox.adaptive(
                  value: _quantities[rule.name]![index] > 0,
                  shape: const CircleBorder(),
                  side: BorderSide(color: playerTheme.accent, width: 1.6),
                  activeColor: playerTheme.accent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: enabled
                      ? (value) => _toggleRule(rule, index, value ?? false)
                      : null,
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );

  List<Widget> _leftBody() => [
    _sectionTitle('BASE POINTS'),
    ...ScoringRules.baseRules.map(_leftRow),
    const SizedBox(height: 12),
    ...ScoringRules.bonusRules.map(_leftRow),
  ];

  List<Widget> _rightBody() => [
    const SizedBox(height: _sectionTitleHeight),
    ...ScoringRules.baseRules.map(_rightRow),
    const SizedBox(height: 12),
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
                  const SizedBox(height: 2),
                  Text(
                    'Honor: Winds and Dragons',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _leftBody(),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rightBody(),
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

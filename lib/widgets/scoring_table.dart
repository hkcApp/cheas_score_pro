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

  final Map<String, List<int>> _quantities = {};



  @override
  void initState() {
    super.initState();
    _initialize();
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



  void _increment(
    String ruleName,
    int playerIndex,
    int maxValue,
  ) {

    final values =
        _quantities[ruleName]!;

    // Maximum of 4 melds (Chow/Pong/Kong) per player.
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

      if (meldTotal >= 4) {
        return;
      }

    }

    if (values[playerIndex] < maxValue) {

      setState(() {

        values[playerIndex]++;

      });


      widget.onChanged(
        _quantities,
      );
    }
  }




  void _decrement(
    String ruleName,
    int playerIndex,
  ) {

    final values =
        _quantities[ruleName]!;


    if (values[playerIndex] > 0) {

      setState(() {

        values[playerIndex]--;

      });


      widget.onChanged(
        _quantities,
      );
    }
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

      width:
          double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),


      child:
          Text(

        title,

        style:
            const TextStyle(
          fontSize: 16,
          fontWeight:
              FontWeight.bold,
        ),

      ),
    );
  }



  Widget _buildHeader() {
    final game = GameService.instance.currentGame!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 170,
          child: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Text(
              "Combination",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 35,
          child: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Text(
              "Pts",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),

        ...List.generate(game.players.length, (index) {
          final player = game.players[index];

          

          return Expanded(
            child: PlayerHeader(
              key: ValueKey("${player.id}-${player.wind}"),

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
      ],
    );
  }


  Widget _buildRow(
    ScoringRule rule,
  ) {


    final isBonus =
        _isBonusRule(rule);



    final isToggle =
        _isToggleBonus(
          rule.name,
        );



    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 1,
      ),



      child:
          Row(

        children: [



          SizedBox(

            width: 170,

            child:
                Text(

              rule.name,

              style:
                  const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w500,
              ),

            ),

          ),




          SizedBox(

            width: 35,

            child:
                Text(

              rule.points.toString(),

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                fontSize: 14,
              ),

            ),

          ),




          ...List.generate(

            widget.playerNames.length,

            (index) {


              final enabled =
                  !isBonus ||
                  index ==
                      widget.winnerIndex;



              if (isToggle) {

                final playerTheme =
                    PlayerColors.player(index);

                return Expanded(

                  child: Center(

                    child: Container(

                      padding:
                          const EdgeInsets.all(4),

                      decoration:
                          BoxDecoration(

                        color:
                            enabled
                                ? playerTheme.background
                                    .withValues(
                                      alpha: 0.35,
                                    )
                                : Colors.transparent,

                        borderRadius:
                            BorderRadius.circular(6),

                      ),

                      child:
                          Switch(

                        value:
                            _quantities[
                                    rule.name]![index] >
                                0,

                        activeThumbColor:
                            playerTheme.accent,

                        onChanged:
                            enabled
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

    return Expanded(
      key: ValueKey('${rule.name}-$index-checkbox'),

      child: Center(

        child: Checkbox.adaptive(

          key: ValueKey(
            '${rule.name}-${widget.playerNames[index]}',
          ),

          value:
              _quantities[rule.name]![index] == 1,

          onChanged:
              enabled
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



              return Expanded(

                child:
                    Center(

                  child:
                      QuantityControl(
                        value:
                            _quantities[
                                rule.name]![index],

                        maxValue:
                            rule.maxQuantity,

                        enabled:
                            enabled,

                        playerColor:
                            PlayerColors
                                .player(index)
                                .accent,


                    onIncrement:
                        () {

                      if (enabled) {

                        _increment(
                          rule.name,
                          index,
                          rule.maxQuantity,
                        );

                      }

                    },


                    onDecrement:
                        () {

                      if (enabled) {

                        _decrement(
                          rule.name,
                          index,
                        );

                      }

                    },

                  ),

                ),

              );

            },

          ),

        ],

      ),

    );

  }






  Widget _buildRules(
    List<ScoringRule> rules,
  ) {

    return Column(

      children:
          rules.map(

        (rule) {

          return _buildRow(
            rule,
          );

        },

      ).toList(),

    );

  }






  @override
  Widget build(
    BuildContext context,
  ) {


    return SingleChildScrollView(

      scrollDirection:
          Axis.horizontal,


      child:
          SizedBox(

        width: 760,


        child:
            Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,


          children: [


            _buildHeader(),


            const Divider(
              height: 8,
            ),



            _buildSectionTitle(
              "BASE POINTS",
            ),



            _buildRules(
              ScoringRules.baseRules,
            ),



            const SizedBox(
              height: 8,
            ),



            _buildSectionTitle(
              "BONUS POINTS",
            ),



            _buildRules(
              ScoringRules.bonusRules,
            ),


          ],

        ),

      ),

    );

  }

}
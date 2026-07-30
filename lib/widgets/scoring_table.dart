import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';
import 'quantity_control.dart';

class ScoringTable extends StatefulWidget {
  const ScoringTable({
    super.key,
    required this.playerNames,
    required this.winnerIndex,
    required this.onWinnerChanged,
    required this.onChanged,
  });

  final List<String> playerNames;
  final int winnerIndex;
  final ValueChanged<int> onWinnerChanged;
  final ValueChanged<Map<String, List<int>>> onChanged;

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


        final otherRule =
            ruleName ==
                    'Self-draw Chip Mahjong'
                ? 'Discarded Chip Mahjong'
                : 'Self-draw Chip Mahjong';



        _quantities[otherRule]![playerIndex] =
            0;

      }


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
          fontSize: 18,
          fontWeight:
              FontWeight.bold,
        ),

      ),
    );
  }





  Widget _buildHeader() {

    return Row(

      children: [

        const SizedBox(

          width: 170,

          child:
              Text(
            "Combination",

            style:
                TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 15,
            ),
          ),

        ),



        const SizedBox(

          width: 35,

          child:
              Text(
            "Pts",

            style:
                TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 15,
            ),
          ),

        ),



        ...widget.playerNames
            .asMap()
            .entries
            .map(

          (entry) {

            final index =
                entry.key;

            final name =
                entry.value;


            final selected =
                widget.winnerIndex ==
                    index;



            return Expanded(

              child:
                  GestureDetector(

                onTap:
                    () {
                  _selectWinner(
                    index,
                  );
                },


                child:
                    Container(

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 4,
                  ),


                  decoration:
                      BoxDecoration(

                    color:
                        selected
                            ? Colors.blue
                            : Colors.transparent,


                    borderRadius:
                        BorderRadius.circular(
                      4,
                    ),

                  ),


                  child:
                      Center(

                    child:
                        Text(

                      name,

                      style:
                          TextStyle(

                        fontSize: 15,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            selected
                                ? Colors.white
                                : Colors.black,

                      ),

                    ),

                  ),

                ),

              ),

            );

          },

        ),

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


                return Expanded(

                  child:
                      Center(

                    child:
                        Switch(

                      value:
                          _quantities[
                                  rule.name]![index] >
                              0,


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
              "BONUS POINTS (WINNER ONLY)",
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
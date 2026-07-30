import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../services/score_service.dart';
import '../widgets/scoring_table.dart';


class ScoreScreen extends StatefulWidget {

  const ScoreScreen({
    super.key,
  });


  @override
  State<ScoreScreen> createState() =>
      _ScoreScreenState();

}



class _ScoreScreenState
    extends State<ScoreScreen> {


  final GlobalKey<ScoringTableState>
      _tableKey =
          GlobalKey<ScoringTableState>();


  int winnerIndex = 0;


  Map<String, List<int>> currentQuantities = {};




  void _winnerChanged(
    int index,
  ) {

    setState(() {

      winnerIndex = index;


      _tableKey
          .currentState
          ?.clearAll();

    });

  }





  int _calculateBaseScore(
    int playerIndex,
  ) {

    int total = 0;


    for (final rule in ScoringRules.baseRules) {


      final quantities =
          currentQuantities[rule.name];


      if (quantities != null) {

        total +=
            quantities[playerIndex] *
            rule.points;

      }

    }


    return total;

  }





  Map<String, int> _calculateWinnerBonus() {


    final Map<String, int> result = {};



    for (final rule in ScoringRules.bonusRules) {


      final quantities =
          currentQuantities[rule.name];



      if (quantities != null) {


        final value =
            quantities[winnerIndex];



        if (value > 0) {


          result[rule.name] =
              value * rule.points;

        }

      }

    }


    return result;

  }







  Future<void> _saveRound() async {


    final game =
        GameService.instance.currentGame;



    if (game == null) {

      return;

    }




    final Map<int, int> scores = {};





    for (int i = 0;
        i < game.players.length;
        i++) {



      final base =
          _calculateBaseScore(i);





      if (i == winnerIndex) {


        int bonus = 0;



        final winnerBonus =
            _calculateWinnerBonus();




        for (final value in winnerBonus.values) {

          bonus += value;

        }





        scores[game.players[i].id] =
            base + bonus;



      } else {


        scores[game.players[i].id] =
            -base;


      }


    }






    final success =
        const ScoreService()
            .applyHandScore(


      game: game,


      winnerId:
          game.players[winnerIndex].id,



      playerScores:
          scores,



      baseQuantities:
          currentQuantities,



      bonusQuantities:
          _calculateWinnerBonus(),


    );







    if (success) {



      await GameService.instance
          .saveCurrentGame();




      setState(() {});



      _tableKey
          .currentState
          ?.clearAll();



      currentQuantities.clear();




      ScaffoldMessenger.of(context)
          .showSnackBar(


        const SnackBar(

          content:
              Text(
            "Round saved",
          ),

        ),


      );


    }


  }








  @override
  Widget build(
    BuildContext context,
  ) {



    final game =
        GameService.instance.currentGame;




    if (game == null) {



      return Scaffold(


        appBar:
            AppBar(

          title:
              const Text(
            "Score Board",
          ),

        ),



        body:
            const Center(

          child:
              Text(
            "No active game.",
          ),

        ),


      );


    }








    return Scaffold(


      appBar:
          AppBar(


        title:
            const Text(
          "Score Board",
        ),


      ),





      body:
          Column(


        children: [





          Padding(


            padding:
                const EdgeInsets.symmetric(

              horizontal: 12,

              vertical: 6,

            ),





            child:
                Column(



              children: [






                Row(



                  children: [



                    const SizedBox(
                      width: 170,
                    ),



                    const SizedBox(
                      width: 35,
                    ),




                    Expanded(



                      child:
                          Center(



                        child:
                            Text(



                          "Round ${game.round}",



                          style:
                              const TextStyle(

                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,

                          ),



                        ),



                      ),



                    ),





                    const Expanded(

                      child:
                          SizedBox(),

                    ),






                    Expanded(



                      child:
                          Center(



                        child:
                            Text(



                          "Running Totals",



                          style:
                              const TextStyle(

                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,

                          ),



                        ),



                      ),



                    ),





                    const Expanded(

                      child:
                          SizedBox(),

                    ),



                  ],



                ),






                const SizedBox(
                  height: 4,
                ),







                Row(



                  children: [



                    const SizedBox(
                      width: 205,
                    ),






                    ...game.players.map(



                      (player) {



                        return Expanded(



                          child:
                              Center(



                            child:
                                Text(



                              "${player.name}: ${player.score}",



                              style:
                                  const TextStyle(



                                fontSize: 14,

                                fontWeight:
                                    FontWeight.w500,

                              ),



                            ),



                          ),



                        );



                      },



                    ),



                  ],



                ),





              ],



            ),



          ),






          const Divider(
            height: 8,
          ),








          Expanded(



            child:
                SingleChildScrollView(



              child:
                  ScoringTable(



                key:
                    _tableKey,



                playerNames:
                    game.players
                        .map(
                          (player) =>
                              player.name,
                        )
                        .toList(),



                winnerIndex:
                    winnerIndex,



                onWinnerChanged:
                    _winnerChanged,



                onChanged:
                    (values) {



                  currentQuantities =
                      values.map(



                    (key, value) =>



                        MapEntry(

                          key,

                          List<int>.from(
                            value,
                          ),

                        ),



                  );



                },



              ),



            ),



          ),







          Padding(



            padding:
                const EdgeInsets.only(

              top: 2,

              bottom: 8,

            ),





            child:
                Center(



              child:
                  SizedBox(



                width:
                    180,



                height:
                    42,



                child:
                    ElevatedButton(



                  style:
                      ElevatedButton.styleFrom(



                    elevation:
                        6,



                    shape:
                        RoundedRectangleBorder(



                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),



                    ),



                    padding:
                        EdgeInsets.zero,



                  ),





                  onPressed:
                      _saveRound,





                  child:
                      const Text(



                    "SAVE ROUND",



                    style:
                        TextStyle(



                      fontSize:
                          17,



                      fontWeight:
                          FontWeight.bold,



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


}
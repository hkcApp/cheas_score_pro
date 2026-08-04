import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';
import '../services/game_service.dart';
import '../services/score_service.dart';
import '../services/scoring_value_service.dart';
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

  @override
  void initState() {
    super.initState();
    ScoringValueService.instance.load().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  final GlobalKey<ScoringTableState>
      _tableKey =
          GlobalKey<ScoringTableState>();


  int winnerIndex = -1;


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

      final points =
          ScoringValueService.instance.getPoints(
        rule.name,
      );

      if (quantities != null) {

        total +=
            quantities[playerIndex] *
            points;

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

          final points =
              ScoringValueService.instance.getPoints(
            rule.name,
          );

          result[rule.name] =
              value * points;

        }

      }

    }


    return result;

  }



  Future<void> _saveRound() async {

    final game = GameService.instance.currentGame;

    if (game == null) {
      return;
    }

    final Map<int, int> scores = {};

    for (int i = 0; i < game.players.length; i++) {

      final base = _calculateBaseScore(i);

      if (i == winnerIndex) {

        int bonus = 0;

        final winnerBonus = _calculateWinnerBonus();

        for (final value in winnerBonus.values) {
          bonus += value;
        }

        scores[game.players[i].id] = base + bonus;

      } else {

        scores[game.players[i].id] = -base;

      }
    }

    final success =
        const ScoreService().applyHandScore(

      game: game,

      winnerId: game.players[winnerIndex].id,

      playerScores: scores,

      baseQuantities: currentQuantities,

      bonusQuantities: _calculateWinnerBonus(),

    );

    if (success) {

      await GameService.instance.saveCurrentGame();

      if (!mounted) return;

      setState(() {});

      _tableKey.currentState?.clearAll();

      currentQuantities.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Round saved"),
        ),
      );
    }
  }





  Future<void> _undoLastRound() async {

    final game = GameService.instance.currentGame;

    if (game == null) return;

    final success = const ScoreService().undoLastHand(
      game: game,
    );

    if (!success) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nothing to undo."),
        ),
      );

      return;
    }

    await GameService.instance.saveCurrentGame();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Last round undone."),
      ),
    );
  }




  @override
  Widget build(
    BuildContext context,
  ) {

    final game =
        GameService.instance.currentGame;

    if (winnerIndex == -1) {
      winnerIndex = game?.eastIndex ?? 0;
    }


    if (game == null) {

      return Scaffold(

        appBar:
            AppBar(

          title:
              const Text(
            "🀄 Chea's Mahjong Score Board",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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
          "🀄 Chea's Mahjong Score Board",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

      ),



      body:
          Column(

        children: [


          const SizedBox(
            height: 4,
          ),



          const Divider(
            height: 8,
          ),



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
                  onPlayerNameChanged: (playerIndex, newName) {
                    setState(() {
                      game.players[playerIndex].name = newName;
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _undoLastRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      "UNDO",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 180,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _saveRound,
                    child: const Text(
                      "SAVE ROUND",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  }

}
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../services/game_service.dart';
import 'score_screen.dart';


class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() =>
      _NewGameScreenState();
}



class _NewGameScreenState
    extends State<NewGameScreen> {


  final player1Controller =
      TextEditingController(
    text: 'Player 1',
  );


  final player2Controller =
      TextEditingController(
    text: 'Player 2',
  );


  final player3Controller =
      TextEditingController(
    text: 'Player 3',
  );


  final player4Controller =
      TextEditingController(
    text: 'Player 4',
  );



  @override
  void dispose() {

    player1Controller.dispose();
    player2Controller.dispose();
    player3Controller.dispose();
    player4Controller.dispose();

    super.dispose();
  }




  void _startGame() {

    GameService.instance.startNewGame(

      playerNames: [

        player1Controller.text.trim(),

        player2Controller.text.trim(),

        player3Controller.text.trim(),

        player4Controller.text.trim(),

      ],

    );


    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const ScoreScreen(),

      ),

    );

  }




  Widget playerField(
    String label,
    TextEditingController controller,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),


      child:
          TextField(

        controller:
            controller,


        decoration:
            InputDecoration(

          labelText:
              label,


          border:
              const OutlineInputBorder(),

        ),

      ),

    );

  }




  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar:
          AppBar(

        title:
            const Text(
          AppStrings.newGame,
        ),

      ),



      body:
          Padding(

        padding:
            const EdgeInsets.all(
          20,
        ),


        child:
            Column(

          children: [


            playerField(
              "Player 1",
              player1Controller,
            ),


            playerField(
              "Player 2",
              player2Controller,
            ),


            playerField(
              "Player 3",
              player3Controller,
            ),


            playerField(
              "Player 4",
              player4Controller,
            ),



            const SizedBox(
              height: 20,
            ),



            SizedBox(

              width:
                  double.infinity,


              height:
                  55,


              child:
                  ElevatedButton(

                onPressed:
                    _startGame,


                child:
                    const Text(

                  "Start Game",

                  style:
                      TextStyle(
                    fontSize: 18,
                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}
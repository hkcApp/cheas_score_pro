import '../models/game.dart';
import 'storage_service.dart';


class GameService {

  GameService._();


  static final GameService instance =
      GameService._();



  Game? _currentGame;



  Game? get currentGame =>
      _currentGame;



  bool get hasActiveGame =>
      _currentGame != null;





  void startNewGame({

    required List<String> playerNames,

  }) {


    _currentGame =
        Game();



    _currentGame!
        .setPlayerNames(
      playerNames,
    );


  }





  Future<void> saveCurrentGame() async {


    final game =
        _currentGame;



    if (game == null) {

      return;

    }



    await StorageService.instance
        .saveGame(
          game,
        );

  }






  Future<bool> loadSavedGame() async {


    final game =
        await StorageService.instance
            .loadGame();



    if (game == null) {

      return false;

    }



    _currentGame =
        game;



    return true;

  }






  Future<void> deleteSavedGame() async {


    await StorageService.instance
        .deleteGame();


    _currentGame =
        null;

  }







  void endGame() {

    _currentGame =
        null;

  }







  void resetCurrentGame() {


    _currentGame
        ?.resetGame();



    saveCurrentGame();

  }







  void nextRound() {


    _currentGame
        ?.nextRound();



    saveCurrentGame();

  }







  Game requireCurrentGame() {


    final game =
        _currentGame;



    if (game == null) {


      throw Exception(
        'No active game.',
      );

    }



    return game;

  }


}
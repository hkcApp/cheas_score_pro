import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';



class StorageService {

  StorageService._();


  static final StorageService instance =
      StorageService._();



  static const String _savedGameKey =
      'cheas_score_pro_current_game';



  Future<void> saveGame(
    Game game,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();


    await prefs.setString(

      _savedGameKey,

      jsonEncode(
        game.toJson(),
      ),

    );

  }




  Future<Game?> loadGame() async {

    final prefs =
        await SharedPreferences.getInstance();


    final data =
        prefs.getString(
          _savedGameKey,
        );


    if (data == null) {

      return null;

    }


    return Game.fromJson(

      jsonDecode(
        data,
      ),

    );

  }




  Future<void> deleteGame() async {

    final prefs =
        await SharedPreferences.getInstance();


    await prefs.remove(
      _savedGameKey,
    );

  }




  Future<bool> hasSavedGame() async {

    final prefs =
        await SharedPreferences.getInstance();


    return prefs.containsKey(
      _savedGameKey,
    );

  }

}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String _savedGameKey =
      'cheas_score_pro_current_game';

  static const String _lastPlayerNamesKey =
      'cheas_score_pro_last_player_names';

  Future<void> saveGame(Game game) async {
    final prefs =
        await SharedPreferences.getInstance();

    final json =
        jsonEncode(
          game.toJson(),
        );

    debugPrint("====== SAVING GAME ======");

    for (final p in game.players) {
      debugPrint(
        "${p.name}   Wind:${p.wind}   Score:${p.score}",
      );
    }

    await prefs.setString(
      _savedGameKey,
      json,
    );

    // Save the latest player names separately so they
    // survive starting a new game.
    await saveLastPlayerNames(
      game.players
          .map((p) => p.name)
          .toList(),
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

    final game = Game.fromJson(
      jsonDecode(data),
    );

    debugPrint("====== LOADED GAME ======");

    for (final p in game.players) {
      debugPrint(
        "${p.name}   Wind:${p.wind}   Score:${p.score}",
      );
    }

    return game;
  }

  Future<void> deleteGame() async {
    final prefs =
        await SharedPreferences.getInstance();

    // Only delete the current game.
    // Do NOT delete the remembered player names.
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

  /// Saves the most recently used player names.
  Future<void> saveLastPlayerNames(
    List<String> names,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _lastPlayerNamesKey,
      names,
    );

    debugPrint("====== SAVING LAST PLAYER NAMES ======");

    for (final name in names) {
      debugPrint(name);
    }
  }

  /// Loads the last player names.
  /// Falls back to default names if none have been saved yet.
  Future<List<String>> loadLastPlayerNames() async {
    final prefs =
        await SharedPreferences.getInstance();

    final names =
        prefs.getStringList(
          _lastPlayerNamesKey,
        );

    if (names != null && names.length == 4) {
      debugPrint("====== LOADED LAST PLAYER NAMES ======");

      for (final name in names) {
        debugPrint(name);
      }

      return names;
    }

    return const [
      "Player 1",
      "Player 2",
      "Player 3",
      "Player 4",
    ];
  }
}
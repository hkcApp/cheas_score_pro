import 'package:flutter/foundation.dart';

import '../models/game.dart';
import 'storage_service.dart';

class GameService {
  GameService._();

  static final GameService instance = GameService._();

  static const List<String> _defaultPlayerNames = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
  ];

  Game? _currentGame;

  Game? get currentGame => _currentGame;

  bool get hasActiveGame => _currentGame != null;

  /// Starts a brand-new game while remembering the most recently
  /// used player names.
  Future<void> startNewGame() async {
    debugPrint("========== START NEW GAME ==========");

    List<String> names;

    if (_currentGame != null) {
      // Starting a new game from an active game.
      names = _currentGame!.players
          .map((p) => p.name)
          .toList();
    } else {
      // App just launched or no game in memory.
      names =
          await StorageService.instance.loadLastPlayerNames();

      if (names.length != 4) {
        names = List<String>.from(_defaultPlayerNames);
      }
    }

    debugPrint("Names being used:");
    for (final name in names) {
      debugPrint(name);
    }

    final game = Game();

    game.setPlayerNames(names);

    _currentGame = game;

    // saveGame() also remembers the player names.
    await saveCurrentGame();
  }

  Future<void> saveCurrentGame() async {
    final game = _currentGame;

    if (game == null) {
      debugPrint("saveCurrentGame(): No active game.");
      return;
    }

    debugPrint("========== saveCurrentGame() ==========");
    debugPrint("Players before saving:");

    for (final p in game.players) {
      debugPrint(
        "${p.name}   Wind:${p.wind}   Score:${p.score}",
      );
    }

    await StorageService.instance.saveGame(game);

    debugPrint("Game saved.");
  }

  Future<bool> loadSavedGame() async {
    debugPrint("========== loadSavedGame() ==========");

    final game =
        await StorageService.instance.loadGame();

    if (game == null) {
      debugPrint("No saved game found.");
      return false;
    }

    _currentGame = game;

    debugPrint("Loaded players:");

    for (final p in game.players) {
      debugPrint(
        "${p.name}   Wind:${p.wind}   Score:${p.score}",
      );
    }

    return true;
  }

  /// Deletes the saved game but keeps the remembered player names.
  Future<void> deleteSavedGame() async {
    debugPrint("========== deleteSavedGame() ==========");

    await StorageService.instance.deleteGame();

    _currentGame = null;
  }

  void endGame() {
    _currentGame = null;
  }

  Future<void> resetCurrentGame() async {
    final game = _currentGame;

    if (game == null) return;

    game.resetGame();

    await saveCurrentGame();
  }

  Future<void> nextRound() async {
    final game = _currentGame;

    if (game == null) return;

    game.nextRound();

    await saveCurrentGame();
  }

  Game requireCurrentGame() {
    final game = _currentGame;

    if (game == null) {
      throw Exception('No active game.');
    }

    return game;
  }
}
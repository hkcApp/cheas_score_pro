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
    List<String> names;

    if (_currentGame != null) {
      // Starting a new game from an active game.
      names = _currentGame!.players.map((p) => p.name).toList();
    } else {
      // App just launched or no game in memory.
      names = await StorageService.instance.loadLastPlayerNames();

      if (names.length != 4) {
        names = List<String>.from(_defaultPlayerNames);
      }
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
      return;
    }

    await StorageService.instance.saveGame(game);
  }

  Future<bool> loadSavedGame() async {
    final game = await StorageService.instance.loadGame();

    if (game == null) {
      return false;
    }

    _currentGame = game;

    return true;
  }

  /// Deletes the saved game but keeps the remembered player names.
  Future<void> deleteSavedGame() async {
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

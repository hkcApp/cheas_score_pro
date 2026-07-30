import '../models/game.dart';
import '../models/score_transaction.dart';

class ScoreService {
  const ScoreService();

  /// Apply a completed Mahjong hand.
  ///
  /// playerScores:
  /// Key   = player ID
  /// Value = score change for that round
  ///
  /// Example:
  /// {
  ///   1: 24,
  ///   2: -6,
  ///   3: -4,
  ///   4: -7,
  /// }
  ///
  /// baseQuantities:
  /// Stores the combinations entered for each player.
  ///
  /// bonusQuantities:
  /// Stores the winner's bonus entries only.
  bool applyHandScore({
    required Game game,
    required int winnerId,
    required Map<int, int> playerScores,
    required Map<String, List<int>> baseQuantities,
    required Map<String, int> bonusQuantities,
  }) {
    if (!game.players.any(
      (player) => player.id == winnerId,
    )) {
      return false;
    }

    // Update running totals.
    for (final player in game.players) {
      final change = playerScores[player.id] ?? 0;

      if (change > 0) {
        player.addScore(change);
      } else if (change < 0) {
        player.subtractScore(change.abs());
      }
    }

    // Save transaction history.
    game.addTransaction(
      ScoreTransaction(
        round: game.round,
        winnerId: winnerId,
        playerDeltas: playerScores,
        baseQuantities: baseQuantities,
        bonusQuantities: bonusQuantities,
        timestamp: DateTime.now(),
      ),
    );

    // Prepare next round.
    game.round++;

    return true;
  }


  /// Undo the most recent hand.
  ///
  /// Restores player totals and removes history entry.
  bool undoLastHand({
    required Game game,
  }) {
    final transaction = game.removeLastTransaction();

    if (transaction == null) {
      return false;
    }

    for (final player in game.players) {
      final change =
          transaction.playerDeltas[player.id] ?? 0;

      if (change > 0) {
        player.subtractScore(change);
      } else if (change < 0) {
        player.addScore(change.abs());
      }
    }

    if (game.round > 1) {
      game.round--;
    }

    return true;
  }
}
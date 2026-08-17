import 'player.dart';
import 'score_transaction.dart';

class Game {
  Game({List<Player>? players, this.round = 1, this.dealer = 0})
      : players =
            players ??
            [
              Player(id: 1, name: 'Player 1', wind: 'E'),
              Player(id: 2, name: 'Player 2', wind: 'S'),
              Player(id: 3, name: 'Player 3', wind: 'W'),
              Player(id: 4, name: 'Player 4', wind: 'N'),
            ];

  final List<Player> players;

  final List<ScoreTransaction> transactions = [];

  int round;

  int dealer;

  void setPlayerNames(List<String> names) {
    for (int i = 0; i < players.length && i < names.length; i++) {
      players[i].name = names[i];
    }
  }

  void addTransaction(ScoreTransaction transaction) {
    transactions.add(transaction);
  }

  ScoreTransaction? removeLastTransaction() {
    if (transactions.isEmpty) {
      return null;
    }

    return transactions.removeLast();
  }

  void nextRound() {
    round++;
  }

  void clearCurrentHand() {}

  void resetGame() {
    for (final player in players) {
      player.resetScore();
    }

    transactions.clear();

    round = 1;
    dealer = 0;

    players[0].wind = "E";
    players[1].wind = "S";
    players[2].wind = "W";
    players[3].wind = "N";
  }

  void nextDealer() {
    dealer = (dealer + 1) % players.length;
  }

  Player getDealer() {
    return players[dealer];
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((p) => p.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'round': round,
      'dealer': dealer,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    final game = Game(
      players: (json['players'] as List)
          .map(
            (item) => Player.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      round: json['round'] as int,
      dealer: json['dealer'] as int,
    );

    game.transactions.addAll(
      (json['transactions'] as List).map(
        (item) => ScoreTransaction.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ),
    );

    return game;
  }

  int get eastIndex => players.indexWhere((p) => p.wind == "E");

  /// Used ONLY during Round 1 when the user selects who starts as East.
  void setStartingEast(int index) {
    const winds = ["E", "S", "W", "N"];

    for (int i = 0; i < players.length; i++) {
      players[(index + i) % players.length].wind = winds[i];
    }
  }

  /// Rotate winds among ACTIVE players only.
  ///
  /// An empty player name means the player is inactive.
  /// Inactive players are skipped completely during rotation.
  void rotateWinds() {
    final activePlayers = players
        .where(
          (player) => player.name.trim().isNotEmpty,
        )
        .toList();

    if (activePlayers.isEmpty) {
      return;
    }

    // Save the current winds of active players only.
    final previousWinds = activePlayers
        .map((player) => player.wind)
        .toList();

    // Move each active player's wind to the next active player.
    // Inactive players are completely skipped.
    for (var index = 0; index < activePlayers.length; index++) {
      activePlayers[(index + 1) % activePlayers.length].wind =
          previousWinds[index];
    }
  }

  /// Update winds after a round.
  ///
  /// If East wins, East remains East.
  /// If another active player wins, winds rotate among
  /// active players only.
  void updateWindsAfterRound(int winnerId) {
    final eastIndex = players.indexWhere(
      (player) =>
          player.wind == "E" &&
          player.name.trim().isNotEmpty,
    );

    if (eastIndex == -1) {
      return;
    }

    if (players[eastIndex].id != winnerId) {
      rotateWinds();
    }
  }
}
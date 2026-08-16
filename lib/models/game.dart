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
          .map((item) => Player.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      round: json['round'] as int,
      dealer: json['dealer'] as int,
    );

    game.transactions.addAll(
      (json['transactions'] as List).map(
        (item) => ScoreTransaction.fromJson(Map<String, dynamic>.from(item)),
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

  void rotateWinds() {
    if (players.isEmpty) {
      return;
    }

    // Move each player's current wind to the next player in display order:
    // Haig -> Ravy -> Lisa -> Chris. This moves East from the first player
    // to the second player, rather than changing East itself into South.
    final previousWinds = players.map((player) => player.wind).toList();
    for (var index = 0; index < players.length; index++) {
      players[(index + 1) % players.length].wind = previousWinds[index];
    }
  }

  void updateWindsAfterRound(int winnerId) {
    final east = players.firstWhere((p) => p.wind == "E");

    if (east.id != winnerId) {
      rotateWinds();
    }
  }
}

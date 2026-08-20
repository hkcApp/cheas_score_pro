import 'player.dart';
import 'score_transaction.dart';

class Game {
  Game({
    List<Player>? players,
    this.round = 1,
    this.dealer = 0,
    Map<String, int>? lastWinningSelections,
    this.lastWinningPlayerId,
  })  : players =
            players ??
            [
              Player(id: 1, name: 'Player 1', wind: 'E'),
              Player(id: 2, name: 'Player 2', wind: 'S'),
              Player(id: 3, name: 'Player 3', wind: 'W'),
              Player(id: 4, name: 'Player 4', wind: 'N'),
            ],
        lastWinningSelections =
            lastWinningSelections != null
                ? Map<String, int>.from(lastWinningSelections)
                : {};

  final List<Player> players;

  final List<ScoreTransaction> transactions = [];

  int round;

  int dealer;

  /// The player ID of the most recent winner.
  ///
  /// This is persisted so Resume Game can restore the actual
  /// winner instead of defaulting to East.
  int? lastWinningPlayerId;

  /// The complete selection made by the most recent winner.
  ///
  /// This includes:
  /// - the selected Base Point pattern
  /// - Self-draw Chip Mahjong, if selected
  /// - Discarded Chip Mahjong, if selected
  Map<String, int> lastWinningSelections;

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

    // A reset game has no previous winner or winning pattern.
    lastWinningPlayerId = null;
    lastWinningSelections.clear();

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
      'lastWinningPlayerId': lastWinningPlayerId,
      'lastWinningSelections': lastWinningSelections,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    final savedSelections =
        json['lastWinningSelections'] is Map
            ? Map<String, int>.from(
                (json['lastWinningSelections'] as Map).map(
                  (key, value) => MapEntry(
                    key.toString(),
                    (value as num).toInt(),
                  ),
                ),
              )
            : <String, int>{};

    final savedWinnerId =
        json['lastWinningPlayerId'] == null
            ? null
            : (json['lastWinningPlayerId'] as num).toInt();

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
      lastWinningPlayerId: savedWinnerId,
      lastWinningSelections: savedSelections,
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

    final previousWinds = activePlayers
        .map((player) => player.wind)
        .toList();

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
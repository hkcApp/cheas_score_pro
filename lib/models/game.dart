import 'player.dart';
import 'score_transaction.dart';


class Game {

  Game({
    List<Player>? players,
    this.round = 1,
    this.dealer = 0,
  }) :
    players = players ??
        [
          Player(id: 1, name: 'Player 1'),
          Player(id: 2, name: 'Player 2'),
          Player(id: 3, name: 'Player 3'),
          Player(id: 4, name: 'Player 4'),
        ];



  final List<Player> players;



  final List<ScoreTransaction> transactions = [];



  int round;



  int dealer;




  void setPlayerNames(
    List<String> names,
  ) {

    for (
      int i = 0;
      i < players.length &&
          i < names.length;
      i++
    ) {

      players[i].name =
          names[i];

    }

  }




  void addTransaction(
    ScoreTransaction transaction,
  ) {

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

  }




  void nextDealer() {

    dealer =
        (dealer + 1) %
        players.length;

  }




  Player getDealer() {

    return players[dealer];

  }




  // ==========================
  // SAVE / LOAD SUPPORT
  // ==========================


  Map<String, dynamic> toJson() {

    return {

      'players':
          players
              .map(
                (player) =>
                    player.toJson(),
              )
              .toList(),


      'transactions':
          transactions
              .map(
                (transaction) =>
                    transaction.toJson(),
              )
              .toList(),


      'round':
          round,


      'dealer':
          dealer,

    };

  }





  factory Game.fromJson(
    Map<String, dynamic> json,
  ) {


    final game = Game(

      players:
          (json['players']
                  as List)
              .map(
                (item) =>
                    Player.fromJson(
                      Map<String, dynamic>
                          .from(item),
                    ),
              )
              .toList(),


      round:
          json['round'] as int,


      dealer:
          json['dealer'] as int,

    );



    game.transactions.addAll(

      (json['transactions']
              as List)
          .map(

            (item) =>
                ScoreTransaction.fromJson(
                  Map<String, dynamic>
                      .from(item),
                ),

          ),

    );


    return game;

  }

}
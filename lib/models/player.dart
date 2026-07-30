class Player {
  Player({
    required this.id,
    required this.name,
    this.score = 0,
  });


  final int id;

  String name;

  int score;



  void addScore(
    int points,
  ) {
    score += points;
  }



  void subtractScore(
    int points,
  ) {
    score -= points;
  }



  void resetScore() {
    score = 0;
  }



  // ==========================
  // SAVE / LOAD SUPPORT
  // ==========================

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'name': name,

      'score': score,

    };
  }



  factory Player.fromJson(
    Map<String, dynamic> json,
  ) {

    return Player(

      id:
          json['id'] as int,


      name:
          json['name'] as String,


      score:
          json['score'] as int,

    );

  }

}
class Player {
  Player({
    required this.id,
    required this.name,
    required this.score,
    required this.seat,
    this.isDealer = false,
  });

  final int id;

  String name;

  int score;

  /// 0 = East
  /// 1 = South
  /// 2 = West
  /// 3 = North
  int seat;

  bool isDealer;

  String get wind {
    switch (seat) {
      case 0:
        return "Ⓔ";
      case 1:
        return "Ⓢ";
      case 2:
        return "Ⓦ";
      default:
        return "Ⓝ";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'seat': seat,
      'isDealer': isDealer,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      score: json['score'],
      seat: json['seat'] ?? 0,
      isDealer: json['isDealer'] ?? false,
    );
  }
}
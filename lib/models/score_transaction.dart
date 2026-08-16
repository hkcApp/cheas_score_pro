class ScoreTransaction {
  ScoreTransaction({
    required this.round,
    required this.winnerId,
    required this.playerDeltas,
    required this.baseQuantities,
    required this.bonusQuantities,
    required this.timestamp,
  });

  /// Round number.
  final int round;

  /// Winning player ID.
  final int winnerId;

  /// Score changes for each player.
  final Map<int, int> playerDeltas;

  /// Base scoring quantities.
  final Map<String, List<int>> baseQuantities;

  /// Bonus scoring quantities.
  final Map<String, int> bonusQuantities;

  /// Time saved.
  final DateTime timestamp;

  // ==========================
  // SAVE / LOAD SUPPORT
  // ==========================

  Map<String, dynamic> toJson() {
    return {
      'round': round,

      'winnerId': winnerId,

      'playerDeltas': playerDeltas.map(
        (key, value) => MapEntry(key.toString(), value),
      ),

      'baseQuantities': baseQuantities,

      'bonusQuantities': bonusQuantities,

      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScoreTransaction.fromJson(Map<String, dynamic> json) {
    return ScoreTransaction(
      round: json['round'] as int,

      winnerId: json['winnerId'] as int,

      playerDeltas: (json['playerDeltas'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), value as int),
      ),

      baseQuantities: (json['baseQuantities'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<int>.from(value)),
      ),

      bonusQuantities: (json['bonusQuantities'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as int),
      ),

      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

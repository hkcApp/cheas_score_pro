import 'package:flutter/material.dart';

/// ===============================================================
/// Chea Scoreboard V2
/// Player Model
///
/// Purpose:
/// Represents one Mahjong player.
///
/// Stores:
/// - Player name
/// - Accent color
/// - Running total
/// - Current round total
/// - Winner selection
///
/// This model is JSON serializable so it can be saved locally.
/// ===============================================================

class Player {
  Player({
    required this.id,
    required this.name,
    required this.accentColor,
    this.runningTotal = 0,
    this.roundTotal = 0,
    this.isWinner = false,
  });

  /// Player number (0-3)
  final int id;

  /// Editable player name
  String name;

  /// Player accent color
  final Color accentColor;

  /// Total accumulated score
  int runningTotal;

  /// Current round score
  int roundTotal;

  /// Winner of this round
  bool isWinner;

  //==============================================================
  // Utility
  //==============================================================

  void resetRound() {
    roundTotal = 0;
    isWinner = false;
  }

  void commitRound() {
    runningTotal += roundTotal;
    resetRound();
  }

  void resetGame() {
    runningTotal = 0;
    resetRound();
  }

  //==============================================================
  // JSON Serialization
  //==============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accentColor': accentColor.value,
      'runningTotal': runningTotal,
      'roundTotal': roundTotal,
      'isWinner': isWinner,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      accentColor: Color(json['accentColor'] as int),
      runningTotal: json['runningTotal'] as int,
      roundTotal: json['roundTotal'] as int,
      isWinner: json['isWinner'] as bool,
    );
  }

  Player copyWith({
    String? name,
    int? runningTotal,
    int? roundTotal,
    bool? isWinner,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      accentColor: accentColor,
      runningTotal: runningTotal ?? this.runningTotal,
      roundTotal: roundTotal ?? this.roundTotal,
      isWinner: isWinner ?? this.isWinner,
    );
  }
}
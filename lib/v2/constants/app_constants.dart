import 'package:flutter/material.dart';

/// ===============================================================
/// Chea Scoreboard V2
/// Application Constants
///
/// This file contains all fixed values used throughout the app.
/// ===============================================================

class AppConstants {
  AppConstants._();

  // ===========================================================
  // App
  // ===========================================================

  static const String appName = 'Chea Scoreboard';

  static const int playerCount = 4;

  static const int startingRound = 1;

  static const int maxPlayerNameLength = 12;

  // ===========================================================
  // Layout
  // ===========================================================

  static const double spacingXS = 4;

  static const double spacingS = 8;

  static const double spacingM = 12;

  static const double spacingL = 16;

  static const double spacingXL = 24;

  static const double borderRadius = 10;

  static const double categoryColumnWidth = 150;

  static const double assignedPointColumnWidth = 72;

  static const double minimumStepperWidth = 62;

  static const double playerHeaderHeight = 42;

  static const Duration animationDuration =
      Duration(milliseconds: 180);

  // ===========================================================
  // Default Player Names
  // ===========================================================

  static const List<String> defaultPlayers = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
  ];

  // ===========================================================
  // Player Accent Colors
  // ===========================================================

  static const List<Color> playerColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  // ===========================================================
  // Base Point Categories
  //
  // IMPORTANT:
  // We will replace these with the exact categories from your
  // existing scoring engine in the next milestone.
  // ===========================================================

  static const Map<String, int> defaultBasePoints = {
    'Flowers': 1,
  };

  // ===========================================================
  // Bonus Categories
  //
  // Placeholder for now.
  // These will also be replaced with your existing values.
  // ===========================================================

  static const Map<String, int> defaultBonusPoints = {
    'Self-drawn': 10,
    'Discarded': 5,
  };
}
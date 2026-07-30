import 'package:flutter/material.dart';

/// ===============================================================
/// Chea Scoreboard V2
/// App Colors
///
/// Purpose:
/// Defines the color palette used throughout the application.
/// Keeping colors in one place makes it easy to adjust the look
/// without touching the UI code.
/// ===============================================================

class AppColors {
  AppColors._();

  // -----------------------------------------------------------------
  // Primary Theme
  // -----------------------------------------------------------------

  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF546E7A);

  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;

  static const Color border = Color(0xFFE0E0E0);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);

  // -----------------------------------------------------------------
  // Player Accent Colors
  // -----------------------------------------------------------------

  static const Color player1 = Color(0xFF1E88E5); // Blue
  static const Color player2 = Color(0xFF43A047); // Green
  static const Color player3 = Color(0xFFFB8C00); // Orange
  static const Color player4 = Color(0xFF8E24AA); // Purple

  static const List<Color> playerAccentColors = [
    player1,
    player2,
    player3,
    player4,
  ];

  // -----------------------------------------------------------------
  // Winner Highlight Colors
  // Very light tint so text remains easy to read.
  // -----------------------------------------------------------------

  static const Color player1Highlight = Color(0xFFEAF4FF);
  static const Color player2Highlight = Color(0xFFEAF7EC);
  static const Color player3Highlight = Color(0xFFFFF4E8);
  static const Color player4Highlight = Color(0xFFF6ECFA);

  static const List<Color> playerHighlightColors = [
    player1Highlight,
    player2Highlight,
    player3Highlight,
    player4Highlight,
  ];

  // -----------------------------------------------------------------
  // Status Colors
  // -----------------------------------------------------------------

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);

  // -----------------------------------------------------------------
  // Score Grid
  // -----------------------------------------------------------------

  static const Color categoryColumn = Colors.white;

  static const Color assignedColumn = Color(0xFFF2F2F2);

  static const Color totalRow = Color(0xFFF7F7F7);

  // -----------------------------------------------------------------
  // Buttons
  // -----------------------------------------------------------------

  static const Color nextRound = primary;

  static const Color endGame = Color(0xFF757575);
}
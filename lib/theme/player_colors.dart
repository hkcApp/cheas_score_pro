import 'package:flutter/material.dart';

/// Represents the complete color palette for one player.
class PlayerThemeData {
  const PlayerThemeData({
    required this.background,
    required this.foreground,
    required this.border,
    required this.accent,
  });

  /// Light background tint used for cards and buttons.
  final Color background;

  /// Main text color.
  final Color foreground;

  /// Border and divider color.
  final Color border;

  /// Accent color used for values and highlights.
  final Color accent;
}

/// Central location for all player colors.
///
/// Player colors NEVER rotate.
/// Winds rotate.
/// Colors belong to the player seat.
class PlayerColors {
  PlayerColors._();

  static const List<PlayerThemeData> themes = [
    PlayerThemeData(
      background: Color(0xFFFFEBEE), // Red 50
      foreground: Color(0xFFB71C1C), // Red 900
      border: Color(0xFFEF9A9A),     // Red 200
      accent: Color(0xFFC62828),     // Red 800
    ),
    PlayerThemeData(
      background: Color(0xFFE3F2FD), // Blue 50
      foreground: Color(0xFF0D47A1), // Blue 900
      border: Color(0xFF90CAF9),     // Blue 200
      accent: Color(0xFF1565C0),     // Blue 800
    ),
    PlayerThemeData(
      background: Color(0xFFE8F5E9), // Green 50
      foreground: Color(0xFF1B5E20), // Green 900
      border: Color(0xFFA5D6A7),     // Green 200
      accent: Color(0xFF2E7D32),     // Green 800
    ),
    PlayerThemeData(
      background: Color(0xFFFFF8E1), // Amber 50
      foreground: Color(0xFFE65100), // Orange 900
      border: Color(0xFFFFE082),     // Amber 200
      accent: Color(0xFFFF8F00),     // Amber 800
    ),
  ];

  /// Returns the theme for the given player seat.
  ///
  /// Seat 0 = Player 1
  /// Seat 1 = Player 2
  /// Seat 2 = Player 3
  /// Seat 3 = Player 4
  static PlayerThemeData player(int index) {
    return themes[index % themes.length];
  }
}
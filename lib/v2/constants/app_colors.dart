import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Theme
  static const Color primary = Color(0xFF1565C0);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);

  // Player Colors
  static const Color player1 = Color(0xFFE53935); // Red
  static const Color player2 = Color(0xFF1E88E5); // Blue
  static const Color player3 = Color(0xFF43A047); // Green
  static const Color player4 = Color(0xFFFB8C00); // Orange

  static const List<Color> playerColors = [
    player1,
    player2,
    player3,
    player4,
  ];

  // Status
  static const Color winner = Color(0xFFFFD54F);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFE53935);

  // Borders
  static const Color divider = Color(0xFFE0E0E0);
}
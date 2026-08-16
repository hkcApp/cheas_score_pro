import 'package:flutter/material.dart';

/// Central text styles used throughout the application.
class AppTextStyles {
  AppTextStyles._();

  /// App bar title
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  /// Large screen title
  static const TextStyle screenTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  /// Section titles (Base Points / Bonus Points)
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Player name
  static const TextStyle playerName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  /// Player wind
  static const TextStyle playerWind = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Rule names
  static const TextStyle ruleName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  /// Numeric values
  static const TextStyle value = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  /// Current score
  static const TextStyle score = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  /// General body text
  static const TextStyle body = TextStyle(fontSize: 16);

  /// Small helper text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );
}

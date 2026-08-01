/// Centralized spacing values used throughout the application.
///
/// Using named spacing values keeps the UI consistent and avoids
/// "magic numbers" scattered throughout the code.
class AppSpacing {
  AppSpacing._();

  /// Extra small (4)
  static const double xs = 4;

  /// Small (8)
  static const double sm = 8;

  /// Medium (16)
  static const double md = 16;

  /// Large (24)
  static const double lg = 24;

  /// Extra large (32)
  static const double xl = 32;

  /// Screen padding
  static const double screen = 24;

  /// Standard card radius
  static const double cardRadius = 12;

  /// Larger radius for featured cards
  static const double largeRadius = 16;

  /// Default button height
  static const double buttonHeight = 48;

  /// Minimum touch target for accessibility
  static const double touchTarget = 48;
}
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';

/// ===============================================================
/// Chea Scoreboard V2
/// App Theme
///
/// Purpose:
/// Central Material 3 theme for the entire application.
///
/// Every widget should use this theme instead of hard-coded
/// colors, fonts or spacing.
/// ===============================================================

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,

      // ----------------------------------------------------------
      // App Bar
      // ----------------------------------------------------------
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      // ----------------------------------------------------------
      // Cards
      // ----------------------------------------------------------
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1,
        margin: const EdgeInsets.all(AppConstants.spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
        ),
      ),

      // ----------------------------------------------------------
      // Text Theme
      // ----------------------------------------------------------
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        bodyLarge: TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),

        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),

        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ----------------------------------------------------------
      // Filled Button (Next Round)
      // ----------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(120, 46),
          backgroundColor: AppColors.nextRound,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius,
            ),
          ),
        ),
      ),

      // ----------------------------------------------------------
      // Outlined Button (End Game)
      // ----------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 46),
          foregroundColor: AppColors.endGame,
          side: const BorderSide(
            color: AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius,
            ),
          ),
        ),
      ),

      // ----------------------------------------------------------
      // Dialog
      // ----------------------------------------------------------
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
        ),
      ),

      // ----------------------------------------------------------
      // Input Decoration
      // ----------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),

      // ----------------------------------------------------------
      // Radio Buttons
      // ----------------------------------------------------------
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),

      // ----------------------------------------------------------
      // Divider
      // ----------------------------------------------------------
      dividerColor: AppColors.border,

      // ----------------------------------------------------------
      // Splash
      // ----------------------------------------------------------
      splashFactory: InkRipple.splashFactory,
    );
  }
}
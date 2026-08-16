import 'package:flutter/material.dart';

import 'constants/app_strings.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CheaScoreProApp());
}

class CheaScoreProApp extends StatelessWidget {
  const CheaScoreProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,

      // Centralized application theme
      theme: AppTheme.light,

      home: const HomeScreen(),
    );
  }
}

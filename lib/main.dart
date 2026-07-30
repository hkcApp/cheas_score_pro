import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'screens/home_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
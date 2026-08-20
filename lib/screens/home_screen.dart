import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/game_service.dart';
import '../widgets/menu_button.dart';

import 'history_screen.dart';
import 'help_screen.dart';
import 'how_to_play_screen.dart';
import 'score_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _newGame(BuildContext context) async {
    await GameService.instance.startNewGame();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScoreScreen(),
      ),
    );
  }

  Future<void> _resumeGame(BuildContext context) async {
    final loaded = await GameService.instance.loadSavedGame();

    if (!context.mounted) return;

    if (!loaded) {
      await GameService.instance.startNewGame();
    }

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScoreScreen(),
      ),
    );
  }

  void _openGameHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
      ),
    );
  }

  void _openGameRules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpScreen(),
      ),
    );
  }

  void _openHowToPlay(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HowToPlayScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/home_photo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  AppStrings.scoreKeeper,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  AppStrings.welcome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 40),

                // 1. NEW GAME
                MenuButton(
                  icon: Icons.play_arrow,
                  title: AppStrings.newGame,
                  onPressed: () => _newGame(context),
                ),

                const SizedBox(height: 16),

                // 2. RESUME SAVED GAME
                MenuButton(
                  icon: Icons.restore,
                  title: 'Resume Saved Game',
                  onPressed: () => _resumeGame(context),
                ),

                const SizedBox(height: 16),

                // 3. GAME HISTORY
                MenuButton(
                  icon: Icons.history,
                  title: AppStrings.gameHistory,
                  onPressed: () => _openGameHistory(context),
                ),

                const SizedBox(height: 16),

                // 4. GAME RULES
                MenuButton(
                  icon: Icons.rule,
                  title: 'Game Rules',
                  onPressed: () => _openGameRules(context),
                ),

                const SizedBox(height: 16),

                // 5. HOW TO PLAY CHINESE MAHJONG
                MenuButton(
                  icon: Icons.menu_book,
                  title: 'How to Play Chinese Mahjong',
                  onPressed: () => _openHowToPlay(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/game_service.dart';
import '../widgets/menu_button.dart';

import 'history_screen.dart';
import 'score_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  Future<void> _resumeGame(
    BuildContext context,
  ) async {
    final loaded =
        await GameService.instance.loadSavedGame();

    if (!context.mounted) return;

    // If no saved game exists, start a new one.
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

  Future<void> _newGame(
    BuildContext context,
  ) async {
    await GameService.instance.startNewGame();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScoreScreen(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appTitle,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.casino,
                  size: 96,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
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

                MenuButton(
                  icon: Icons.play_arrow,
                  title: AppStrings.newGame,
                  onPressed: () => _newGame(context),
                ),

                const SizedBox(height: 16),

                MenuButton(
                  icon: Icons.restore,
                  title: "Resume Saved Game",
                  onPressed: () => _resumeGame(context),
                ),

                const SizedBox(height: 16),

                MenuButton(
                  icon: Icons.history,
                  title: AppStrings.gameHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                MenuButton(
                  icon: Icons.settings,
                  title: AppStrings.settings,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
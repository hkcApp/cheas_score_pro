import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to Play Chinese Mahjong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _section(
              '1. The Goal',
              'The goal of Mahjong is to complete a winning hand. '
                  'A standard hand is normally made from four groups and one pair. '
                  'The Game Rules section shows the scoring patterns recognized by this app.',
            ),

            _section(
              '2. What is a Chow?',
              'A Chow is a group of three consecutive numbered tiles in the same suit. '
                  'For example, 2-3-4 or 6-7-8. '
                  'Honor tiles such as Winds and Dragons cannot be used to make a Chow.',
            ),

            _section(
              '3. What is a Pung?',
              'A Pung is a group of three identical tiles. '
                  'For example, three 7 Dot tiles or three Red Dragon tiles.',
            ),

            _section(
              '4. What is a Kong?',
              'A Kong is a group of four identical tiles. '
                  'For example, four 9 Bamboo tiles or four East Wind tiles. '
                  'A Kong counts as one group when determining the winning hand.',
            ),

            _section(
              '5. What is a Pair?',
              'A Pair consists of two identical tiles. '
                  'A standard winning hand normally ends with one pair.',
            ),

            _section(
              '6. Suits',
              'There are three numbered suits: Characters, Bamboo, and Dots. '
                  'Each suit contains the numbers 1 through 9.',
            ),

            _section(
              '7. Honor Tiles',
              'Honor tiles are Winds and Dragons. '
                  'The four Winds are East, South, West, and North. '
                  'The three Dragons are Red Dragon, Green Dragon, and White Dragon.',
            ),

            _section(
              '8. Selecting the Winning Player',
              'Tap the winner selection circle under the player who won the hand. '
                  'Only the selected winner can receive the points for the winning pattern.',
            ),

            _section(
              '9. Selecting a Game Rule',
              'Select the scoring pattern that matches the winning hand. '
                  'The app uses one base scoring pattern for each winning hand. '
                  'The available patterns and their point values are listed under Game Rules.',
            ),

            _section(
              '10. Self-draw Chip Mahjong',
              'Select Self-draw Chip Mahjong when the winning tile was drawn by the winning player. '
                  'The score is distributed according to the app scoring rules.',
            ),

            _section(
              '11. Discarded Chip Mahjong',
              'Select Discarded Chip Mahjong when another player discarded the tile that completed '
                  'the winning hand. The app applies the corresponding scoring multiplier.',
            ),

            _section(
              '12. Save Round',
              'After selecting the winner and scoring pattern, press SAVE ROUND to record the hand. '
                  'The scores are added to the players and the round is saved.',
            ),

            _section(
              '13. Undo',
              'Press UNDO to reverse the most recently saved round. '
                  'Use this if a round was entered incorrectly.',
            ),

            _section(
              '14. Reset',
              'Press Reset to restore the scoring point values to their default values. '
                  'This does not reset the players or erase saved rounds.',
            ),

            _section(
              '15. Game History',
              'Game History lets you review previously saved rounds and scores.',
            ),

            const SizedBox(height: 10),

            const Text(
              'Tip: If you are new to Mahjong, start with the Game Rules screen. '
              'Each pattern includes a beginner-friendly description and an example.',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
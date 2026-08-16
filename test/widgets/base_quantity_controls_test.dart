import 'package:chea_score_pro/services/game_service.dart';
import 'package:chea_score_pro/widgets/scoring_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('base-point patterns and outcome chips use circular selections', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await GameService.instance.startNewGame();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 700,
            child: ScoringTable(
              playerNames: const ['Haig', 'Ravy', 'Lisa', 'Chris'],
              runningTotals: const [0, 0, 0, 0],
              winnerIndex: 0,
              onWinnerChanged: (_) {},
              onChanged: (_) {},
              onPlayerNameChanged: (_, _) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('BASE POINTS'), findsOneWidget);
    expect(find.text('Nine Gates'), findsOneWidget);
    expect(find.text('Self-draw Chip Mahjong'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(56));
  });
}

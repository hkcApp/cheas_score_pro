import 'package:chea_score_pro/services/game_service.dart';
import 'package:chea_score_pro/widgets/quantity_control.dart';
import 'package:chea_score_pro/widgets/scoring_table.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('base selectors enforce pattern-specific quantity limits', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await GameService.instance.startNewGame();
    late Map<String, List<int>> quantities;
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
              onChanged: (changed) {
                quantities = changed.map(
                  (key, value) => MapEntry(key, List<int>.from(value)),
                );
              },
              onPlayerNameChanged: (_, _) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('BASE POINTS'), findsOneWidget);
    expect(find.text('Nine Gate'), findsOneWidget);
    expect(find.text('Pung'), findsOneWidget);
    expect(find.byTooltip('Three identical numbered tiles.'), findsOneWidget);
    expect(find.text('Self-draw Chip'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(28));
    expect(find.byType(QuantityControl), findsNWidgets(24));

    final selectors = find.byType(QuantityControl);
    final titleFinder = find.text('Pung');
    final titleCenter = tester.getCenter(titleFinder);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: titleCenter);
    await mouse.moveTo(titleCenter);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Three identical numbered tiles.'), findsOneWidget);
    await mouse.removePointer();

    expect(tester.widget<QuantityControl>(selectors.at(0)).maxValue, 4);
    expect(tester.widget<QuantityControl>(selectors.at(20)).maxValue, 2);
    expect(tester.getSize(selectors.first), const Size(24, 24));
    expect(
      tester
          .widget<Text>(
            find.descendant(of: selectors.first, matching: find.byType(Text)),
          )
          .style
          ?.fontWeight,
      FontWeight.bold,
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(of: selectors.first, matching: find.byType(Text)),
          )
          .style
          ?.fontSize,
      14,
    );
    final inactiveColumn = find.ancestor(
      of: selectors.at(1),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(inactiveColumn.first).opacity, 0.4);

    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(quantities['Chow']![0], 2);
    expect(tester.widget<QuantityControl>(selectors.at(4)).maxValue, 2);

    await tester.tap(selectors.at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(tester.widget<QuantityControl>(selectors.at(20)).maxValue, 0);
    expect(quantities['Pung']![0], 2);
    expect(quantities['Double Sequence']![0], 0);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(quantities['Pure Triple Chow']![0], 0);

    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();
    await tester.tap(selectors.at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(quantities['Pure Triple Chow']![0], 1);
    expect(tester.widget<QuantityControl>(selectors.at(0)).maxValue, 1);
    for (final index in [8, 12, 16]) {
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).at(index));
      expect(checkbox.onChanged, isNull);
      expect(checkbox.side?.color, Colors.grey.shade400);
    }

    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    expect(tester.widget<QuantityControl>(selectors.at(4)).maxValue, 0);
    expect(tester.widget<QuantityControl>(selectors.at(20)).maxValue, 0);
    expect(tester.widget<QuantityControl>(selectors.at(20)).enabled, isFalse);

    await tester.tap(find.byType(Checkbox).at(4));
    await tester.pumpAndSettle();
    expect(quantities['Pure Straight']![0], 0);
    expect(tester.widget<QuantityControl>(selectors.at(0)).maxValue, 1);
    expect(
      tester.widget<Checkbox>(find.byType(Checkbox).at(4)).onChanged,
      isNull,
    );
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(quantities['Pure Triple Chow']![0], 0);
    await tester.tap(find.byType(Checkbox).at(4));
    await tester.pumpAndSettle();
    expect(quantities['Pure Straight']![0], 1);
    await tester.tap(find.byType(Checkbox).at(4));
    await tester.pumpAndSettle();
    expect(quantities['Pure Straight']![0], 0);

    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();
    await tester.tap(selectors.at(20));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    expect(quantities['Double Sequence']![0], 1);
    expect(tester.widget<QuantityControl>(selectors.at(4)).maxValue, 2);

    await tester.tap(selectors.at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(quantities['Pung']![0], 2);
    expect(tester.widget<QuantityControl>(selectors.at(0)).maxValue, 0);

    await tester.tap(selectors.at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();
    await tester.tap(selectors.at(20));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();
    await tester.tap(selectors.at(20));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(quantities['Double Sequence']![0], 2);
    expect(tester.widget<QuantityControl>(selectors.at(4)).maxValue, 0);
    expect(tester.widget<QuantityControl>(selectors.at(4)).enabled, isFalse);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(quantities['Pure Triple Chow']![0], 0);

    await tester.tap(selectors.at(20));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).at(8));
    await tester.pumpAndSettle();
    expect(quantities['Full Flush']![0], 1);
    expect(tester.widget<QuantityControl>(selectors.first).enabled, isFalse);
    for (final index in [12, 16]) {
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).at(index));
      expect(checkbox.onChanged, isNull);
      expect(checkbox.side?.color, Colors.grey.shade400);
    }
    for (final index in [20, 24]) {
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox).at(index)).onChanged,
        isNotNull,
      );
    }
    await tester.tap(find.byType(Checkbox).at(20));
    await tester.pumpAndSettle();
    expect(quantities['Full Flush']![0], 1);
    expect(quantities['Self-draw Chip Mahjong']![0], 1);
    await tester.tap(find.byType(Checkbox).at(8));
    await tester.pumpAndSettle();
    expect(quantities['Full Flush']![0], 0);

    await tester.tap(find.byType(Checkbox).at(12));
    await tester.pumpAndSettle();
    expect(quantities['Seven Pairs']![0], 1);
    for (final index in [8, 16]) {
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox).at(index)).onChanged,
        isNull,
      );
    }
    await tester.tap(find.byType(Checkbox).at(12));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).at(16));
    await tester.pumpAndSettle();
    expect(quantities['Nine Gate']![0], 1);
    for (final index in [8, 12]) {
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox).at(index)).onChanged,
        isNull,
      );
    }
    expect(
      tester.widget<Checkbox>(find.byType(Checkbox).at(20)).onChanged,
      isNotNull,
    );
    expect(quantities['Nine Gate']![0], 1);
    expect(quantities['Self-draw Chip Mahjong']![0], 1);
    await tester.tap(find.byType(Checkbox).at(16));
    await tester.pumpAndSettle();
    await tester.tap(selectors.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    expect(quantities['Chow']![0], 1);
    expect(quantities['Self-draw Chip Mahjong']![0], 1);
  });
}

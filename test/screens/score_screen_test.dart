import 'package:chea_score_pro/screens/score_screen.dart';
import 'package:chea_score_pro/services/game_service.dart';
import 'package:chea_score_pro/widgets/quantity_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('sums all selected base quantities when saving a round', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await GameService.instance.startNewGame();
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ScoreScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('winner-selector-0')), findsOneWidget);
    final controls = find.byType(QuantityControl);
    for (var index = 0; index < controls.evaluate().length; index++) {
      expect(
        tester.widget<QuantityControl>(controls.at(index)).enabled,
        isFalse,
      );
    }
    await tester.tap(find.byKey(const ValueKey('winner-selector-0')));
    await tester.pumpAndSettle();
    for (var index = 0; index < controls.evaluate().length; index++) {
      expect(
        tester.widget<QuantityControl>(controls.at(index)).enabled,
        index % 4 == 0,
      );
    }

    Future<void> selectQuantity(int index, int quantity) async {
      await tester.tap(find.byType(QuantityControl).at(index));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$quantity').last);
      await tester.pumpAndSettle();
    }

    await selectQuantity(0, 1);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SAVE ROUND'));
    await tester.tap(find.text('SAVE ROUND'));
    await tester.pumpAndSettle();

    final game = GameService.instance.currentGame!;
    expect(game.players[0].score, 22);
    expect(game.transactions.last.baseQuantities['Chow']![0], 1);
    expect(game.transactions.last.baseQuantities['Double Sequence']![0], 0);
    expect(game.transactions.last.baseQuantities['Pure Triple Chow']![0], 1);
    for (var index = 0; index < controls.evaluate().length; index++) {
      expect(
        tester.widget<QuantityControl>(controls.at(index)).enabled,
        isFalse,
      );
    }
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'SAVE ROUND'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('winner-selector-1')));
    await tester.pumpAndSettle();
    for (var index = 0; index < controls.evaluate().length; index++) {
      expect(
        tester.widget<QuantityControl>(controls.at(index)).enabled,
        index % 4 == 1,
      );
    }
  });

  testWidgets('self-draw transfers 5 points from each other active player', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await GameService.instance.startNewGame();
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ScoreScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('winner-selector-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(QuantityControl).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('outcome-self-draw-0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SAVE ROUND'));
    await tester.tap(find.text('SAVE ROUND'));
    await tester.pumpAndSettle();

    final deltas =
        GameService.instance.currentGame!.transactions.last.playerDeltas;
    expect(deltas, {1: 16, 2: -5, 3: -5, 4: -5});
    expect(deltas.values.reduce((total, delta) => total + delta), 1);
  });

  testWidgets(
    'discarded-chip winner gets one 5x opponent-count bonus',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await GameService.instance.startNewGame();
      tester.view.physicalSize = const Size(900, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: ScoreScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('winner-selector-0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(QuantityControl).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1').last);
      await tester.pumpAndSettle();

      expect(find.text('5x3'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('outcome-discarded-0')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('SAVE ROUND'));
      await tester.tap(find.text('SAVE ROUND'));
      await tester.pumpAndSettle();

      final deltas =
          GameService.instance.currentGame!.transactions.last.playerDeltas;
      expect(deltas, {1: 16, 2: -15, 3: -15, 4: -15});
      expect(deltas.values.reduce((total, delta) => total + delta), -29);
    },
  );
}

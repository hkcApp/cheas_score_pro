import 'package:chea_score_pro/widgets/player_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('winner selector invokes its callback', (tester) async {
    var wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlayerHeader(
            playerIndex: 0,
            playerName: 'Haig',
            runningTotal: 0,
            isWinner: false,
            wind: 'E',
            onWinnerTapped: () => wasTapped = true,
            onNameChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('winner-selector-0')));

    expect(wasTapped, isTrue);
  });
}

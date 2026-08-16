import 'package:chea_score_pro/models/scoring_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines the twelve Table 1 base-point patterns', () {
    final points = {
      for (final rule in ScoringRules.baseRules) rule.name: rule.points,
    };

    expect(points, hasLength(12));
    expect(points, containsPair('Chow', 1));
    expect(points, containsPair('Double Sequence', 2));
    expect(points, containsPair('Pure Triple Chow', 3));
    expect(points, containsPair('Mixed One Suit', 3));
    expect(points, containsPair('Three Pungs', 3));
    expect(points, containsPair('All Pungs', 4));
    expect(points, containsPair('Pure Straight', 4));
    expect(points, containsPair('Full Flush (1 Suit)', 5));
    expect(points, containsPair('3 Honor Pungs', 6));
    expect(points, containsPair('Seven Pairs', 6));
    expect(points, containsPair('4 Honor Pungs', 7));
    expect(points, containsPair('Nine Gates', 10));
  });

  test('keeps the two mutually exclusive Mahjong outcome chips', () {
    expect(ScoringRules.bonusRules.map((rule) => rule.name), [
      'Self-draw Chip Mahjong',
      'Discarded Chip Mahjong',
    ]);
  });
}

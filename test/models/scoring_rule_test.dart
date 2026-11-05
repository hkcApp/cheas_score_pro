import 'package:chea_score_pro/models/scoring_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'defines the base-point patterns in display order with their defaults',
    () {
      final points = {
        for (final rule in ScoringRules.baseRules) rule.name: rule.points,
      };

      expect(ScoringRules.baseRules.map((rule) => rule.name), [
        'Chow',
        'Pung',
        'Kong',
        'Honor Pung',
        'Honor Kong',
        'Double Sequence',
        'Pure Triple Chow',
        'Pure Straight',
        'Full Flush',
        'Seven Pairs',
        'Nine Gates',
      ]);

      expect(ScoringRules.baseRules.skip(1).take(4).map((rule) => rule.name), [
        'Pung',
        'Kong',
        'Honor Pung',
        'Honor Kong',
      ]);
      expect(ScoringRules.baseRules[1].description, contains('Three'));
      expect(ScoringRules.baseRules[1].description, contains('numbered tiles'));
      expect(ScoringRules.baseRules[2].description, contains('Four'));
      expect(ScoringRules.baseRules[3].description, contains('Wind or Dragon'));
      expect(ScoringRules.baseRules[4].description, contains('Wind or Dragon'));

      expect(points, hasLength(11));
      expect(points, containsPair('Chow', 1));
      expect(points, containsPair('Pung', 2));
      expect(points, containsPair('Kong', 3));
      expect(points, containsPair('Honor Pung', 4));
      expect(points, containsPair('Honor Kong', 5));
      expect(points, containsPair('Double Sequence', 11));
      expect(points, containsPair('Pure Triple Chow', 21));
      expect(points, containsPair('Pure Straight', 21));
      expect(points, containsPair('Full Flush', 30));
      expect(points, containsPair('Seven Pairs', 30));
      expect(points, containsPair('Nine Gates', 38));
    },
  );

  test('sets dropdown maximum quantities and the combined-selection limit', () {
    expect(ScoringRules.baseRules.map((rule) => rule.maxQuantity), [
      4,
      4,
      4,
      4,
      4,
      2,
      1,
      1,
      1,
      1,
      1,
    ]);
    expect(
      ScoringRules.baseRules
          .where((rule) => rule.countsTowardCombinationLimit)
          .map((rule) => rule.name),
      [
        'Chow',
        'Pung',
        'Kong',
        'Honor Pung',
        'Honor Kong',
        'Double Sequence',
        'Pure Triple Chow',
        'Pure Straight',
      ],
    );
    expect(ScoringRules.maxCombinedQuantity, 4);
  });

  test('keeps the two mutually exclusive Mahjong outcome chips', () {
    expect(ScoringRules.bonusRules.map((rule) => (rule.name, rule.points)), [
      ('Self-draw Chip Mahjong', 5),
      ('Discarded Chip Mahjong', 5),
    ]);
  });
}

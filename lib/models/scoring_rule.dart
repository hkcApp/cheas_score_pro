enum ScoringType { base, bonus }

class ScoringRule {
  const ScoringRule({
    required this.name,
    required this.points,
    required this.type,
    this.description,
    this.example,
    this.maxQuantity = 1,
    this.countsTowardCombinationLimit = false,
  });

  final String name;
  final int points;
  final ScoringType type;
  final String? description;
  final String? example;
  final int maxQuantity;
  final bool countsTowardCombinationLimit;

}

class ScoringRules {
  static const int maxCombinedQuantity = 4;

  static const List<ScoringRule> baseRules = [
    ScoringRule(
      name: 'Chow',
      points: 1,
      type: ScoringType.base,
      maxQuantity: 4,
      countsTowardCombinationLimit: true,
      description:
          'Three consecutive numbered tiles in the same suit. '
          'Honor tiles cannot form a Chow.',
      example: '3-4-5 (DOT), 6-7-8 (BAM), 2-3-4 (CHR) + pair',
    ),
    ScoringRule(
      name: 'Pung',
      points: 2,
      type: ScoringType.base,
      maxQuantity: 4,
      countsTowardCombinationLimit: true,
      description: 'Three identical numbered tiles.',
      example: '7-7-7 (DOT)',
    ),
    ScoringRule(
      name: 'Kong',
      points: 3,
      type: ScoringType.base,
      maxQuantity: 4,
      countsTowardCombinationLimit: true,
      description: 'Four identical numbered tiles. A Kong counts as one meld.',
      example: '9-9-9-9 (BAM)',
    ),
    ScoringRule(
      name: 'Honor Pung',
      points: 4,
      type: ScoringType.base,
      maxQuantity: 4,
      countsTowardCombinationLimit: true,
      description: 'Three identical Wind or Dragon tiles.',
      example: '東-東-東 (East Wind)',
    ),
    ScoringRule(
      name: 'Honor Kong',
      points: 6,
      type: ScoringType.base,
      maxQuantity: 4,
      countsTowardCombinationLimit: true,
      description:
          'Four identical Wind or Dragon tiles. It counts as one meld.',
      example: '中-中-中-中 (Red Dragon)',
    ),
    ScoringRule(
      name: 'Double Sequence',
      points: 8,
      type: ScoringType.base,
      maxQuantity: 2,
      countsTowardCombinationLimit: true,
      description:
          'Two identical Chows in the same suit; both use the same '
          'three consecutive numbers.',
      example: '2-3-4 (CHR) + 2-3-4 (CHR)',
    ),
    ScoringRule(
      name: 'Pure Triple Chow',
      points: 18,
      type: ScoringType.base,
      countsTowardCombinationLimit: true,
      description: 'Three identical Chows in three different suits.',
      example: '4-5-6 (DOT), 4-5-6 (BAM), 4-5-6 (CHR)',
    ),
    ScoringRule(
      name: 'Pure Straight',
      points: 18,
      type: ScoringType.base,
      countsTowardCombinationLimit: true,
      description:
          'Three Chows that use all numbers from 1 through 9 in one suit.',
      example: '1-2-3, 4-5-6, 7-8-9 (all DOT)',
    ),
    ScoringRule(
      name: 'Full Flush',
      points: 18,
      type: ScoringType.base,
      description:
          'Every tile in the hand is from the same numbered suit. '
          'No Honor tiles are allowed.',
      example: 'All tiles are DOT',
    ),
    ScoringRule(
      name: 'Seven Pairs',
      points: 20,
      type: ScoringType.base,
      description:
          'A winning hand made from seven separate pairs of identical tiles.',
      example: 'Seven pairs (14 tiles)',
    ),
    ScoringRule(
      name: 'Nine Gate',
      points: 20,
      type: ScoringType.base,
      description:
          'A concealed hand in one numbered suit: 1112345678999 '
          'plus one additional tile of that suit.',
      example: '1-1-1-2-3-4-5-6-7-8-9-9-9 plus one same-suit tile',
    ),
  ];

  static const List<ScoringRule> bonusRules = [
    ScoringRule(
      name: 'Self-draw Chip Mahjong',
      points: 0,
      type: ScoringType.bonus,
    ),
    ScoringRule(
      name: 'Discarded Chip Mahjong',
      points: 0,
      type: ScoringType.bonus,
    ),
  ];
}

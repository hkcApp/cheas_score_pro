enum ScoringType {
  base,
  bonus,
}

class ScoringRule {
  const ScoringRule({
    required this.name,
    required this.points,
    required this.type,
    this.maxQuantity = 99,
  });

  final String name;
  final int points;
  final ScoringType type;
  final int maxQuantity;
}

class ScoringRules {
  static const List<ScoringRule> baseRules = [
    ScoringRule(
      name: 'Flowers',
      points: 1,
      type: ScoringType.base,
      maxQuantity: 8,
    ),

    ScoringRule(
      name: 'Dragon/Wind Pair',
      points: 2,
      type: ScoringType.base,
      maxQuantity: 1,
    ),

    ScoringRule(
      name: 'Chow',
      points: 2,
      type: ScoringType.base,
      maxQuantity: 4,
    ),

    ScoringRule(
      name: 'Pong',
      points: 4,
      type: ScoringType.base,
      maxQuantity: 4,
    ),

    ScoringRule(
      name: 'Pong (Wind/Dragon)',
      points: 5,
      type: ScoringType.base,
      maxQuantity: 4,
    ),

    ScoringRule(
      name: 'Kong',
      points: 5,
      type: ScoringType.base,
      maxQuantity: 4,
    ),

    ScoringRule(
      name: 'Kong (Wind/Dragon)',
      points: 6,
      type: ScoringType.base,
      maxQuantity: 4,
    ),
  ];

  static const List<ScoringRule> bonusRules = [
    ScoringRule(
      name: '6 Consecutive # (1 suit)',
      points: 5,
      type: ScoringType.bonus,
      maxQuantity: 1,
    ),

    ScoringRule(
      name: '2X 6 Consecutive # (1 suit / 6 tiles)',
      points: 10,
      type: ScoringType.bonus,
      maxQuantity: 1,
    ),

    ScoringRule(
      name: '4 Sets of Pong (12 chips)',
      points: 10,
      type: ScoringType.bonus,
      maxQuantity: 1,
    ),

    ScoringRule(
      name: 'Self-draw Chip Mahjong',
      points: 10,
      type: ScoringType.bonus,
      maxQuantity: 1,
    ),

    ScoringRule(
      name: 'Discarded Chip Mahjong',
      points: 5,
      type: ScoringType.bonus,
      maxQuantity: 1,
    ),
  ];
}
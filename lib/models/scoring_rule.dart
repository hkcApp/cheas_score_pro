enum ScoringType { base, bonus }

class ScoringRule {
  const ScoringRule({
    required this.name,
    required this.points,
    required this.type,
    this.description,
    this.example,
  });

  final String name;
  final int points;
  final ScoringType type;
  final String? description;
  final String? example;
}

class ScoringRules {
  /// A winning hand may use exactly one of these patterns.
  static const List<ScoringRule> baseRules = [
    ScoringRule(
      name: 'Chow',
      points: 1,
      type: ScoringType.base,
      description:
          'Standard winning hand made mostly of sequences. No honors required.',
      example:
          '3-4-5 (筒 DOT), 6-7-8 (索 BAM), 2-3-4 (萬 CHR), 4-5-6 (索 BAM) + pair',
    ),
    ScoringRule(
      name: 'Double Sequence',
      points: 2,
      type: ScoringType.base,
      description: 'Two identical sequences in the same suit.',
      example: '4-5-6 (索 BAM) + 4-5-6 (索 BAM)',
    ),
    ScoringRule(
      name: 'Pure Triple Chow',
      points: 3,
      type: ScoringType.base,
      description:
          'Three identical sequences (same numbers) in three different suits.',
      example: '4-5-6 (筒 DOT), 4-5-6 (索 BAM), 4-5-6 (萬 CHR)',
    ),
    ScoringRule(
      name: 'Mixed One Suit',
      points: 3,
      type: ScoringType.base,
      description:
          'One suit plus honors (Winds/Dragons). Stronger than Ping Wu, easier than Full Flush.',
      example: 'All (索 BAM) tiles + pair 東東 (E-E)',
    ),
    ScoringRule(
      name: 'Three Pungs',
      points: 3,
      type: ScoringType.base,
      description: 'Exactly three Pungs/Kongs in the hand (not all Pungs).',
      example:
          '3-3-3 (索 BAM), 白白白 (White), 9-9-9 (筒 DOT) + one sequence + pair',
    ),
    ScoringRule(
      name: 'All Pungs',
      points: 4,
      type: ScoringType.base,
      description: 'All melds are Pungs/Kongs. No sequences allowed.',
      example: '7-7-7 (索 BAM), 白白白 (White), 9-9-9 (筒 DOT) + pair',
    ),
    ScoringRule(
      name: 'Pure Straight',
      points: 4,
      type: ScoringType.base,
      description:
          'Three sequences forming a complete straight from 1 to 9 in one suit.',
      example: '1-2-3 (筒 DOT), 4-5-6 (筒 DOT), 7-8-9 (筒 DOT)',
    ),
    ScoringRule(
      name: 'Full Flush (1 Suit)',
      points: 5,
      type: ScoringType.base,
      description: 'Entire hand is one suit only. No honors.',
      example: 'All (筒 DOT) tiles: 1-1-1, 3-4-5, 7-8-9 + pair',
    ),
    ScoringRule(
      name: '3 Honor Pungs',
      points: 6,
      type: ScoringType.base,
      description:
          'Three honor Pungs/Kongs (Winds or Dragons). Very strong and rare.',
      example:
          '東東東 (E-E-E) + 白白白 (White-White-White) + 發發發 (Green-Green-Green)',
    ),
    ScoringRule(
      name: 'Seven Pairs',
      points: 6,
      type: ScoringType.base,
      description: 'Win with seven separate pairs instead of melds.',
      example:
          '1-1 (筒 DOT), 3-3 (索 BAM), 白白 (White), 發發 (Green), 7-7 (萬 CHR), 9-9 (筒 DOT), 東東 (E-E)',
    ),
    ScoringRule(
      name: '4 Honor Pungs',
      points: 7,
      type: ScoringType.base,
      description:
          'Entire hand consists of honor Pungs/Kongs only (Winds + Dragons).',
      example:
          '東東東 (E-E-E), 南南南 (S-S-S), 中中中 (Red-Red-Red), 白白白 (White-White-White) + pair',
    ),
    ScoringRule(
      name: 'Nine Gates',
      points: 10,
      type: ScoringType.base,
      description:
          'Legendary concealed pure-suit hand: 111 234567 999 plus any tile of the same suit.',
      example:
          'DOT suit: 1-1-1 (筒 DOT), 2-3-4-5-6-7 (筒 DOT), 9-9-9 (筒 DOT) + any DOT tile',
    ),
  ];

  /// These outcome chips remain independent of the selected base pattern.
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

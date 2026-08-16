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
          'A Chow is 3 consecutive numbered tiles in the same suit. '
          'For example, 3-4-5 is a Chow. Honor tiles cannot be used in a Chow.',
      example:
          '3-4-5 (筒 DOT), 6-7-8 (索 BAM), 2-3-4 (萬 CHR), 4-5-6 (索 BAM) + pair',
    ),

    ScoringRule(
      name: 'Double Sequence',
      points: 2,
      type: ScoringType.base,
      description:
          'A Double Sequence is two identical Chows in the same suit. '
          'Both Chows contain the same three numbers.',
      example:
          '2-3-4 (萬 CHR) + 2-3-4 (萬 CHR)',
    ),

    ScoringRule(
      name: 'Pure Triple Chow',
      points: 3,
      type: ScoringType.base,
      description:
          'A Pure Triple Chow is three identical Chows in three different suits. '
          'The three Chows use the same three numbers.',
      example:
          '4-5-6 (筒 DOT), 4-5-6 (索 BAM), 4-5-6 (萬 CHR)',
    ),

    ScoringRule(
      name: 'Mixed One Suit',
      points: 3,
      type: ScoringType.base,
      description:
          'A Mixed One Suit uses numbered tiles from only one suit together '
          'with Honor tiles. Honor tiles are Winds and Dragons.',
      example:
          '1-2-3 (萬 CHR), 4-5-6 (萬 CHR), 7-8-9 (萬 CHR) + 東 EAST WIND pair',
    ),

    ScoringRule(
      name: '3 Pungs/Kongs',
      points: 3,
      type: ScoringType.base,
      description:
          'A Pung is 3 identical tiles. A Kong is 4 identical tiles. '
          'This pattern contains 3 groups that are Pungs or Kongs. '
          'The remaining group can be a Chow, plus a pair.',
      example:
          '3-3-3 (索 BAM), 白白白 (WHITE DRAGON), 9-9-9 (筒 DOT) + Chow + pair',
    ),

    ScoringRule(
      name: '4 Pungs/Kongs',
      points: 4,
      type: ScoringType.base,
      description:
          'A Pung is 3 identical tiles and a Kong is 4 identical tiles. '
          'This pattern contains 4 groups that are Pungs or Kongs, plus a pair.',
      example:
          '2-2-2 (萬 CHR), 4-4-4 (索 BAM), 6-6-6 (筒 DOT), 8-8-8 (萬 CHR) + pair',
    ),

    ScoringRule(
      name: 'Pure Straight',
      points: 4,
      type: ScoringType.base,
      description:
          'A Pure Straight contains three Chows that together use all nine '
          'numbers from 1 through 9 in the same suit.',
      example:
          '1-2-3 (筒 DOT), 4-5-6 (筒 DOT), 7-8-9 (筒 DOT)',
    ),

    ScoringRule(
      name: 'Full Flush (1 Suit)',
      points: 5,
      type: ScoringType.base,
      description:
          'A Full Flush uses numbered tiles from only one suit for the entire hand. '
          'No Honor tiles are allowed.',
      example:
          '1-2-3 (筒 DOT), 4-5-6 (筒 DOT), 7-8-9 (筒 DOT) + Pung + pair',
    ),

    ScoringRule(
      name: '3 Honor Pungs/Kongs',
      points: 6,
      type: ScoringType.base,
      description:
          'This pattern contains Pungs or Kongs of the three Dragon tiles: '
          'Red Dragon, Green Dragon, and White Dragon.',
      example:
          '中 RED DRAGON, 發 GREEN DRAGON, 白 WHITE DRAGON',
    ),

    ScoringRule(
      name: 'Seven Pairs',
      points: 6,
      type: ScoringType.base,
      description:
          'Seven Pairs is a winning hand made from 7 separate pairs of identical tiles. '
          'It does not use Chows, Pungs, or Kongs.',
      example:
          '2-2 (筒 DOT), 3-3 (索 BAM), 7-7 (萬 CHR), 東 EAST WIND + 3 more pairs',
    ),

    ScoringRule(
      name: '4 Honors Pungs/Kongs',
      points: 7,
      type: ScoringType.base,
      description:
          'This pattern contains Pungs or Kongs of all four Wind tiles: '
          'East Wind, South Wind, West Wind, and North Wind. '
          'Honor tiles cannot form Chows.',
      example:
          '東 EAST WIND, 南 SOUTH WIND, 西 WEST WIND, 北 NORTH WIND + pair',
    ),

    ScoringRule(
      name: 'Nine Gates',
      points: 10,
      type: ScoringType.base,
      description:
          'Nine Gates is a special concealed hand made entirely from one numbered suit. '
          'It contains 1112345678999 plus one additional tile of the same suit.',
      example:
          '1-1-1-2-3-4-5-6-7-8-9-9-9 (萬 CHR) + any additional 萬 CHR',
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
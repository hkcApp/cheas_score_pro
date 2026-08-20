import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // Mahjong tile colors.
  static const Color dotColor = Color(0xFF1565C0);
  static const Color bamColor = Color(0xFF2E7D32);
  static const Color chrColor = Color(0xFFB71C1C);

  static const Color eastColor = Color(0xFF1565C0);
  static const Color southColor = Color(0xFF2E7D32);
  static const Color westColor = Color(0xFFB71C1C);
  static const Color northColor = Color(0xFF6A1B9A);

  static const Color redDragonColor = Color(0xFFD32F2F);
  static const Color greenDragonColor = Color(0xFF2E7D32);
  static const Color whiteDragonColor = Color(0xFF616161);

  Color? _tileColor(String text) {
    if (text.contains('筒')) return dotColor;
    if (text.contains('索')) return bamColor;
    if (text.contains('萬')) return chrColor;

    if (text.contains('東')) return eastColor;
    if (text.contains('南')) return southColor;
    if (text.contains('西')) return westColor;
    if (text.contains('北')) return northColor;

    if (text.contains('中')) return redDragonColor;
    if (text.contains('發')) return greenDragonColor;
    if (text.contains('白')) return whiteDragonColor;

    return null;
  }

  List<TextSpan> _coloredText(
    String text, {
    double fontSize = 11.5,
  }) {
    final spans = <TextSpan>[];
    final parts = text.split(' ');

    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];

      if (part.isEmpty) continue;

      spans.add(
        TextSpan(
          text: part,
          style: TextStyle(
            fontSize: fontSize,
            color: _tileColor(part) ?? Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      );

      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: ' ',
            style: TextStyle(fontSize: fontSize),
          ),
        );
      }
    }

    return spans;
  }

  Widget _quickReferenceLine(List<TextSpan> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        softWrap: true,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 11.5,
            color: Colors.black87,
          ),
          children: children,
        ),
      ),
    );
  }

  TextSpan _normalSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 11.5,
        color: Colors.black87,
      ),
    );
  }

  TextSpan _tileSpan(
    String text, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 12,
        color: _tileColor(text) ?? Colors.black87,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget _quickReference() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(6, 8, 6, 10),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 7),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Reference',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          _quickReferenceLine([
            _normalSpan(
              '• Honor Tile — A tile that is not a numbered suit tile. '
              'Honor tiles are Winds and Dragons.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan('• Wind — '),
            _tileSpan('東'),
            _normalSpan(' East, '),
            _tileSpan('南'),
            _normalSpan(' South, '),
            _tileSpan('西'),
            _normalSpan(' West, '),
            _tileSpan('北'),
            _normalSpan(
              ' North. Winds are Honor tiles and cannot form a Chow.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan('• Dragon — '),
            _tileSpan('中'),
            _normalSpan(' Red Dragon, '),
            _tileSpan('發'),
            _normalSpan(' Green Dragon, '),
            _tileSpan('白'),
            _normalSpan(
              ' White Dragon. Dragons are Honor tiles and cannot form a Chow.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan(
              '• Chow — Three consecutive numbered tiles in the same suit, '
              'such as 2-3-4. Honor tiles cannot be used.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan(
              '• Pung — Three identical tiles, such as 7-7-7 or ',
            ),
            _tileSpan('中 中 中'),
            _normalSpan('.'),
          ]),
          _quickReferenceLine([
            _normalSpan(
              '• Kong — Four identical tiles. A Kong is one meld but '
              'contains four physical tiles.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan(
              '• Pair — Two identical tiles. A standard winning hand needs one pair.',
            ),
          ]),
          _quickReferenceLine([
            _normalSpan(
              '• Winning Hand — Normally four melds plus one pair. '
              'A Kong counts as one meld.',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _headerCell(
    String text, {
    TextAlign alignment = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 6,
      ),
      child: Text(
        text,
        textAlign: alignment,
        softWrap: false,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _bodyCell(
    Widget child, {
    Alignment alignment = Alignment.topLeft,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 6,
      ),
      child: child,
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
      ),
      children: [
        _headerCell('Pattern'),
        _headerCell(
          'Points',
          alignment: TextAlign.center,
        ),
        _headerCell('Detail'),
        _headerCell('Complete Hand Example'),
      ],
    );
  }

  Widget _patternCell(
    int index,
    ScoringRule rule,
  ) {
    return Text(
      '${index + 1}. ${rule.name}',
      softWrap: true,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 11.5,
        color: Colors.black87,
      ),
    );
  }

  Widget _detailCell(ScoringRule rule) {
    return Text(
      rule.description ?? '',
      softWrap: true,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
    );
  }

  Widget _exampleText(String text) {
    final lines = text.split('\n');

    return RichText(
      softWrap: true,
      text: TextSpan(
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            ..._coloredText(
              lines[i],
              fontSize: 11.5,
            ),
            if (i < lines.length - 1)
              const TextSpan(
                text: '\n',
                style: TextStyle(fontSize: 11.5),
              ),
          ],
        ],
      ),
    );
  }

  String _completeExample(int index) {
    switch (index) {
      case 0:
        return 'Example: 2-3-4 筒\n'
            'Complete hand: 2-3-4 筒 | 5-6-7 筒 | '
            '3-4-5 索 | 7-7-7 萬 | 東-東\n'
            'The hand contains four melds and a pair.';

      case 1:
        return 'Example: 2-3-4 筒 | 2-3-4 筒\n'
            'Complete hand: 2-3-4 筒 | 2-3-4 筒 | '
            '6-7-8 索 | 5-5-5 萬 | 中-中\n'
            'The first two melds form the Double Sequence.';

      case 2:
        return 'Example: 1-2-3 筒 | 1-2-3 索 | 1-2-3 萬\n'
            'Complete hand: 1-2-3 筒 | 1-2-3 索 | '
            '1-2-3 萬 | 7-7-7 筒 | 9-9\n'
            'The three identical-number Chows use three different suits.';

      case 3:
        return 'Example: one numbered suit + Honors\n'
            'Complete hand: 1-2-3 筒 | 4-5-6 筒 | '
            '7-8-9 筒 | 中-中-中 | 東-東\n'
            'All numbered tiles are Dots; the remaining tiles are Honors.\n\n'
            'Kong example: 1-2-3 筒 | 4-5-6 筒 | '
            '7-7-7 筒 | 白-白-白-白 | 東-東\n'
            'The White Dragon Kong counts as one meld.';

      case 4:
        return 'Example: 2-2-2 筒 | 5-5-5 索 | '
            '9-9-9 萬 | 3-4-5 筒 | 東-東\n'
            'The three qualifying groups are Pungs.\n\n'
            'Kong example: 2-2-2 筒 | 5-5-5 索 | '
            '中-中-中-中 | 3-4-5 萬 | 東-東\n'
            'The three qualifying groups are two Pungs and one Kong.';

      case 5:
        return 'Example: 2-2-2 筒 | 5-5-5 索 | '
            '7-7-7 萬 | 中-中-中 | 東-東\n'
            'There are four Pungs plus the Pair.\n\n'
            'Kong example: 2-2-2 筒 | 5-5-5 索 | '
            '7-7-7 萬 | 中-中-中-中 | 東-東\n'
            'The four melds are three Pungs and one Kong.';

      case 6:
        return 'Example: 1-2-3 筒 | 4-5-6 筒 | '
            '7-8-9 筒 | 5-5-5 索 | 東-東\n'
            'The first three melds create a complete 1 through 9 '
            'sequence in one suit.';

      case 7:
        return 'Example: 1-2-3 筒 | 4-5-6 筒 | '
            '7-8-9 筒 | 5-5-5 筒 | 2-2 筒\n'
            'Every tile is a Dot. There are no Bamboo, Characters, '
            'or Honor tiles.\n\n'
            'Kong example: 1-2-3 筒 | 4-5-6 筒 | '
            '7-7-7 筒 | 9-9-9-9 筒 | 5-5 筒\n'
            'All tiles remain within the Dot suit.';

      case 8:
        return 'Example: 東-東-東 | 中-中-中 | 白-白-白 | '
            '2-3-4 筒 | 7-7 筒\n'
            'The three qualifying groups are Honor Pungs.\n\n'
            'Kong example: 東-東-東 | 中-中-中 | '
            '白-白-白-白 | 2-3-4 筒 | 7-7 筒\n'
            'The White Dragon group is a Kong.';

      case 9:
        return 'Complete hand — 7 pairs:\n'
            '1-1 筒 | 3-3 筒 | 5-5 索 | 7-7 索 | '
            '2-2 萬 | 東-東 | 中-中\n'
            'Seven pairs = 14 tiles = Mahjong.\n'
            'This special hand does not use the normal '
            'four-melds-plus-pair structure.';

      case 10:
        return 'Example: 東-東-東 | 南-南-南 | 中-中-中 | '
            '白-白-白 | 5-5 筒\n'
            'The four Honor groups are Pungs, plus the Pair.\n\n'
            'Kong example: 東-東-東 | 南-南-南 | 中-中-中 | '
            '白-白-白-白 | 5-5 筒\n'
            'Three Honor Pungs and one Honor Kong, plus the Pair.';

      case 11:
        return 'Nine Gates uses one numbered suit only.\n'
            'Base structure: 1-1-1-2-3-4-5-6-7-8-9-9-9 筒\n'
            'Additional tile: 5 筒\n'
            'Complete hand: 1-1-1-2-3-4-5-5-6-7-8-9-9-9 筒\n'
            'All 14 tiles are Dots. No Bamboo, Characters, or Honors.\n'
            'Normally a concealed hand.';

      default:
        return '';
    }
  }

  TableRow _ruleRow(
    int index,
    ScoringRule rule,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.7,
          ),
        ),
      ),
      children: [
        _bodyCell(
          _patternCell(index, rule),
        ),
        _bodyCell(
          Text(
            '${rule.points}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.black87,
            ),
          ),
          alignment: Alignment.topCenter,
        ),
        _bodyCell(
          _detailCell(rule),
        ),
        _bodyCell(
          _exampleText(
            _completeExample(index),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rules = ScoringRules.baseRules;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Rules'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _quickReference(),

            _sectionTitle(
              '12 Special Winning Patterns',
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  6,
                  0,
                  6,
                  12,
                ),
                child: Table(
                  columnWidths: const {
                    // Pattern — reduced approximately 30%.
                    0: FlexColumnWidth(0.74),

                    // Points — compact.
                    1: FlexColumnWidth(0.45),

                    // Detail — unchanged.
                    2: FlexColumnWidth(1.80),

                    // Complete Hand Example — increased approximately 20%.
                    3: FlexColumnWidth(3.06),
                  },
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 0.6,
                  ),
                  children: [
                    _headerRow(),
                    for (
                      var index = 0;
                      index < rules.length;
                      index++
                    )
                      _ruleRow(
                        index,
                        rules[index],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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

  TextSpan _coloredExample(String example) {
    final parts = <TextSpan>[];
    final words = example.split(' ');

    for (final word in words) {
      Color? color;

      if (word.contains('筒') || word.contains('DOT')) {
        color = dotColor;
      } else if (word.contains('索') || word.contains('BAM')) {
        color = bamColor;
      } else if (word.contains('萬') || word.contains('CHR')) {
        color = chrColor;
      } else if (word.contains('東') || word.contains('EAST')) {
        color = eastColor;
      } else if (word.contains('南') || word.contains('SOUTH')) {
        color = southColor;
      } else if (word.contains('西') || word.contains('WEST')) {
        color = westColor;
      } else if (word.contains('北') || word.contains('NORTH')) {
        color = northColor;
      } else if (word.contains('中') || word.contains('RED')) {
        color = redDragonColor;
      } else if (word.contains('發') || word.contains('GREEN')) {
        color = greenDragonColor;
      } else if (word.contains('白') || word.contains('WHITE')) {
        color = whiteDragonColor;
      }

      parts.add(
        TextSpan(
          text: word,
          style: TextStyle(
            fontSize: 12,
            color: color ?? Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      );

      parts.add(
        const TextSpan(
          text: ' ',
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    return TextSpan(children: parts);
  }

  Widget _example(String text) {
    return RichText(
      softWrap: true,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Example: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
          _coloredExample(text),
        ],
      ),
    );
  }

  Widget _headerCell(
    String text, {
    TextAlign alignment = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 7,
      ),
      child: Text(
        text,
        textAlign: alignment,
        style: const TextStyle(
          fontSize: 12,
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
        horizontal: 4,
        vertical: 7,
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
        _headerCell('Detail Description'),
        _headerCell('Example'),
      ],
    );
  }

  TableRow _ruleRow(int index, ScoringRule rule) {
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
          Text(
            '${index + 1}. ${rule.name}',
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        _bodyCell(
          Text(
            '${rule.points}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          alignment: Alignment.topCenter,
        ),
        _bodyCell(
          Text(
            rule.description ?? '',
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        _bodyCell(
          _example(rule.example ?? ''),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tableWidth = constraints.maxWidth;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  // FIXED HEADER
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.35),
                      1: FlexColumnWidth(0.42),
                      2: FlexColumnWidth(1.85),
                      3: FlexColumnWidth(2.0),
                    },
                    border: TableBorder(
                      left: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.7,
                      ),
                      right: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.7,
                      ),
                      top: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.7,
                      ),
                      verticalInside: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    children: [
                      _headerRow(),
                    ],
                  ),

                  // SCROLLING RULES
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: tableWidth,
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1.35),
                              1: FlexColumnWidth(0.42),
                              2: FlexColumnWidth(1.85),
                              3: FlexColumnWidth(2.0),
                            },
                            border: TableBorder(
                              left: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.7,
                              ),
                              right: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.7,
                              ),
                              verticalInside: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                            children: [
                              for (var index = 0;
                                  index < rules.length;
                                  index++)
                                _ruleRow(index, rules[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
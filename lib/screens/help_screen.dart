import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
            fontSize: 14,
            color: color ?? Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      );

      parts.add(
        const TextSpan(
          text: ' ',
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    return TextSpan(children: parts);
  }

  Widget _example(String text) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Example: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
          _coloredExample(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Rules'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: DataTable(
            columnSpacing: 14,
            horizontalMargin: 6,
            headingRowHeight: 42,
            dataRowMinHeight: 90,
            dataRowMaxHeight: 150,
            columns: const [
              DataColumn(
                label: Text(
                  'Pattern',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Points',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Detail Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Example',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: [
              for (final rule in ScoringRules.baseRules)
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        rule.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${rule.points}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 280,
                        child: Text(
                          rule.description ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 360,
                        child: _example(rule.example ?? ''),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../models/scoring_rule.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Rules')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ScoringRules.baseRules.length,
        separatorBuilder: (_, _) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final rule = ScoringRules.baseRules[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ${rule.name} — ${rule.points} point${rule.points == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(rule.description!, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Text(
                'Example: ${rule.example!}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          );
        },
      ),
    );
  }
}

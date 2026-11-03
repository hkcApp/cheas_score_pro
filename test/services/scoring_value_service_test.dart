import 'dart:convert';

import 'package:chea_score_pro/services/scoring_value_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'updates old defaults and preserves customized renamed values',
    () async {
      SharedPreferences.setMockInitialValues({
        'cheas_score_pro_scoring_values': jsonEncode({
          'Chow': 3,
          'Honor Kong': 6,
          'Double Sequence': 8,
          'Pure Triple Chow': 18,
          'Pure Straight': 18,
          'Pong': 8,
          'Pong (Wind/Dragon)': 9,
          'Full Flush (1 Suit)': 5,
          'Full Flush': 18,
          'Seven Pairs': 20,
          'Nine Gates': 20,
          'Nine Gate': 20,
        }),
      });

      await ScoringValueService.instance.load();

      expect(ScoringValueService.instance.getPoints('Chow'), 3);
      expect(ScoringValueService.instance.getPoints('Honor Kong'), 5);
      expect(ScoringValueService.instance.getPoints('Double Sequence'), 14);
      expect(ScoringValueService.instance.getPoints('Pure Triple Chow'), 21);
      expect(ScoringValueService.instance.getPoints('Pure Straight'), 21);
      expect(ScoringValueService.instance.getPoints('Pung'), 8);
      expect(ScoringValueService.instance.getPoints('Honor Pung'), 9);
      expect(ScoringValueService.instance.getPoints('Full Flush'), 30);
      expect(ScoringValueService.instance.getPoints('Seven Pairs'), 30);
      expect(ScoringValueService.instance.getPoints('Nine Gates'), 38);
    },
  );
}

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
          'Double Sequence': 2,
          'Pong': 8,
          'Pong (Wind/Dragon)': 9,
          'Full Flush (1 Suit)': 5,
          'Nine Gates': 10,
        }),
      });

      await ScoringValueService.instance.load();

      expect(ScoringValueService.instance.getPoints('Chow'), 3);
      expect(ScoringValueService.instance.getPoints('Double Sequence'), 8);
      expect(ScoringValueService.instance.getPoints('Pung'), 8);
      expect(ScoringValueService.instance.getPoints('Honor Pung'), 9);
      expect(ScoringValueService.instance.getPoints('Full Flush'), 18);
      expect(ScoringValueService.instance.getPoints('Nine Gate'), 20);
    },
  );
}

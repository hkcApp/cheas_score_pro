import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/scoring_rule.dart';

class ScoringValueService {
  ScoringValueService._();

  static final ScoringValueService instance = ScoringValueService._();

  static const String _scoringValuesKey = 'cheas_score_pro_scoring_values';

  final Map<String, int> _values = {};
  bool _loaded = false;

  static final Map<String, int> _defaultPoints = {
    for (final rule in [
      ...ScoringRules.baseRules,
      ...ScoringRules.bonusRules,
    ])
      rule.name: rule.points,
  };

  Future<void> load() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_scoringValuesKey);

    if (jsonString == null) {
      _values
        ..clear()
        ..addAll(_defaultPoints);
    } else {
      try {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        _values
          ..clear()
          ..addAll(_defaultPoints);
        for (final entry in data.entries) {
          final value = entry.value;
          if (value is int && _defaultPoints.containsKey(entry.key)) {
            _values[entry.key] = value;
          }
        }
      } catch (_) {
        _values
          ..clear()
          ..addAll(_defaultPoints);
      }
    }

    _loaded = true;
  }

  int getPoints(String ruleName) {
    return _values[ruleName] ?? _defaultPoints[ruleName]!;
  }

  Future<void> setPoints(
    String ruleName,
    int points,
  ) async {
    _values[ruleName] = points;
    await _save();
  }

  Future<void> resetToDefaults() async {
    _values
      ..clear()
      ..addAll(_defaultPoints);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _scoringValuesKey,
      jsonEncode(_values),
    );
  }
}

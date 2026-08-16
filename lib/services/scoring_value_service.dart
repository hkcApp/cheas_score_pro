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
    for (final rule in ScoringRules.baseRules) rule.name: rule.points,
  };

  /// Defaults used before the base-rule values were revised. Values that still
  /// match these are migrated to the new defaults; custom values are retained.
  static const Map<String, int> _previousDefaultPoints = {
    'Chow': 2,
    'Pong': 4,
    'Pong (Wind/Dragon)': 5,
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
            if (_previousDefaultPoints[entry.key] != value) {
              _values[entry.key] = value;
            }
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

  Future<void> setPoints(String ruleName, int points) async {
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
    await prefs.setString(_scoringValuesKey, jsonEncode(_values));
  }
}

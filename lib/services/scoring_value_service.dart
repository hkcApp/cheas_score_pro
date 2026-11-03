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

  /// Older rule names are mapped when their saved points were customized.
  static const Map<String, String> _legacyRuleNames = {
    'Pong': 'Pung',
    'Pong (Wind/Dragon)': 'Honor Pung',
    'Full Flush (1 Suit)': 'Full Flush',
    'Nine Gate': 'Nine Gates',
  };

  /// Previously shipped defaults are reset to the current defaults, while
  /// custom values continue to carry forward.
  static const Map<String, Set<int>> _previousDefaultPoints = {
    'Chow': {1, 2},
    'Honor Kong': {6},
    'Double Sequence': {2, 8},
    'Pure Triple Chow': {3, 18},
    'Pure Straight': {4, 18},
    'Full Flush (1 Suit)': {5},
    'Full Flush': {18},
    'Seven Pairs': {6, 20},
    'Nine Gates': {10, 20},
    'Nine Gate': {20},
    'Pong': {4},
    'Pong (Wind/Dragon)': {5},
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
          final ruleName = _legacyRuleNames[entry.key] ?? entry.key;
          if (value is int && _defaultPoints.containsKey(ruleName)) {
            if (!(_previousDefaultPoints[entry.key]?.contains(value) ??
                false)) {
              _values[ruleName] = value;
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

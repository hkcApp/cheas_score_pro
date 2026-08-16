import 'package:chea_score_pro/models/game.dart';
import 'package:chea_score_pro/models/player.dart';
import 'package:chea_score_pro/services/score_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Game gameWithNamedPlayers() => Game(
    players: [
      Player(id: 1, name: 'Haig', wind: 'E'),
      Player(id: 2, name: 'Ravy', wind: 'S'),
      Player(id: 3, name: 'Lisa', wind: 'W'),
      Player(id: 4, name: 'Chris', wind: 'N'),
    ],
  );

  test('moves Haig wind to Ravy, then Lisa, then Chris', () {
    final game = gameWithNamedPlayers();

    game.rotateWinds();

    expect(
      {for (final player in game.players) player.name: player.wind},
      {'Haig': 'N', 'Ravy': 'E', 'Lisa': 'S', 'Chris': 'W'},
    );
  });

  test('moves Haig East to Ravy after Ravy wins Round 1', () {
    final game = gameWithNamedPlayers();

    const ScoreService().applyHandScore(
      game: game,
      winnerId: 2,
      playerScores: const {1: 0, 2: 0, 3: 0, 4: 0},
      baseQuantities: const {},
      bonusQuantities: const {},
    );

    expect(
      {for (final player in game.players) player.name: player.wind},
      {'Haig': 'N', 'Ravy': 'E', 'Lisa': 'S', 'Chris': 'W'},
    );
  });
}

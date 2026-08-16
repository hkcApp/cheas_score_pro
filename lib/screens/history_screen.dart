import 'package:flutter/material.dart';

import '../services/game_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameService.instance.currentGame;

    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: game == null
          ? const Center(
              child: Text('No active game.', style: TextStyle(fontSize: 20)),
            )
          : game.transactions.isEmpty
          ? const Center(
              child: Text(
                'No score history yet.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: game.transactions.length,
              itemBuilder: (context, index) {
                final transaction = game.transactions[index];

                final winner = game.players.firstWhere(
                  (player) => player.id == transaction.winnerId,
                );

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${transaction.round}')),
                    title: Text(winner.name),
                    subtitle: Text(
                      'Winner: ${winner.name}\n'
                      'Time: ${transaction.timestamp}',
                    ),
                    trailing: Text(
                      '+${transaction.playerDeltas[winner.id] ?? 0}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

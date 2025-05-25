import 'package:flutter/material.dart';
import '../../../models/player_model.dart';

class PlayerListScreen extends StatelessWidget {
  final List<PlayerModel> players;
  const PlayerListScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    // Group players by team
    final Map<String, List<PlayerModel>> grouped = {};
    for (final player in players) {
      grouped.putIfAbsent(player.team, () => []);
      grouped[player.team]!.add(player);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players & Points'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children:
            grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Team: ${entry.key}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (player) => ListTile(
                      leading: Image.asset(
                        'assets/images/dummy.png',
                        width: 40,
                        height: 40,
                      ),
                      title: Text(player.name),
                      subtitle: Text('Points: ${player.points}'),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

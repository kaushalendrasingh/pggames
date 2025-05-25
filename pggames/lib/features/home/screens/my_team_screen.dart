import 'package:flutter/material.dart';
import '../../../models/player_model.dart';

class MyTeamScreen extends StatelessWidget {
  final List<PlayerModel> myPlayers;
  final String? captainId;
  final String? viceCaptainId;
  const MyTeamScreen({
    super.key,
    required this.myPlayers,
    this.captainId,
    this.viceCaptainId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Selected Team'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: myPlayers.length,
        itemBuilder: (context, idx) {
          final player = myPlayers[idx];
          String role = '';
          if (player.id == captainId) role = ' (C)';
          if (player.id == viceCaptainId) role += ' (VC)';
          return ListTile(
            leading: Image.asset(
              'assets/images/dummy.png',
              width: 40,
              height: 40,
            ),
            title: Text(player.name + role),
            subtitle: Text('Points: ${player.points}'),
          );
        },
      ),
    );
  }
}

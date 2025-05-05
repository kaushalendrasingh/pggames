import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  // TODO: Add match card UI and logic
  const MatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Match Title'),
        subtitle: const Text('Match Date'),
        trailing: ElevatedButton(onPressed: () {}, child: const Text('Join')),
      ),
    );
  }
}

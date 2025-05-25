import 'package:flutter/material.dart';
import '../../../models/fantasy_match_model.dart';
import '../../../models/team_model.dart';
import '../../../models/match_model.dart';

class MatchDetailScreen extends StatelessWidget {
  final FantasyMatchModel fantasyMatch;
  final TeamModel team;
  final MatchModel? matchInfo;

  const MatchDetailScreen({
    super.key,
    required this.fantasyMatch,
    required this.team,
    this.matchInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                team.image != null
                    ? Image.network(
                      team.image!,
                      width: 80,
                      height: 80,
                      errorBuilder:
                          (c, e, s) =>
                              const Icon(Icons.sports_cricket, size: 60),
                    )
                    : const Icon(Icons.sports_cricket, size: 60),
                const SizedBox(width: 16),
                Text(
                  team.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (matchInfo != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(matchInfo!.venue, style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(matchInfo!.date, style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.attach_money, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Entry Fee: ₹${fantasyMatch.entryFee}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

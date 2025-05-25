import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/fantasy_match_model.dart';
import '../../../models/fantasy_team_model.dart';
import '../../../models/team_model.dart';
import '../../../models/match_model.dart';
import '../../../models/player_model.dart';
import '../../../utils/match_service.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/api_config.dart';
import '../screens/team_creation_screen.dart';
import 'match_detail_screen.dart';
import 'player_list_screen.dart';
import 'my_team_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FantasyMatchModel>> _todayMatchesFuture;
  late Future<List<FantasyTeamModel>> _userHistoryFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    userId = await AuthService.getUserId();
    setState(() {
      _todayMatchesFuture = MatchService.fetchTodayAndUpcomingMatches();
      _userHistoryFuture =
          userId != null
              ? MatchService.fetchUserMatchHistory(userId!)
              : Future.value([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    _todayMatchesFuture = MatchService.fetchTodayAndUpcomingMatches();
    _userHistoryFuture =
        userId != null
            ? MatchService.fetchUserMatchHistory(userId!)
            : Future.value([]);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Today's Match Banner
          FutureBuilder<List<FantasyMatchModel>>(
            future: _todayMatchesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No matches today.'),
                );
              }
              final match = snapshot.data!.first;
              final homeTeam = match.homeTeam;
              final opponentTeam = match.opponentTeam;
              final matchInfo =
                  homeTeam != null && homeTeam.matches.isNotEmpty
                      ? homeTeam.matches[0]
                      : null;
              // Check if user has already joined
              return FutureBuilder<List<FantasyTeamModel>>(
                future: _userHistoryFuture,
                builder: (context, userSnapshot) {
                  bool alreadyJoined = false;
                  if (userSnapshot.hasData) {
                    alreadyJoined = userSnapshot.data!.any(
                      (team) => team.fantasyMatchId == match.id,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/dummy.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  Text(
                                    homeTeam?.name ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              const Text(
                                'vs',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/dummy.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  Text(
                                    opponentTeam?.name ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Date: ${matchInfo != null ? matchInfo['date'] ?? 'Today' : 'Today'}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Venue: ${matchInfo != null ? matchInfo['venue'] ?? '-' : '-'}',
                          ),
                          const SizedBox(height: 16),
                          if (!alreadyJoined)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TeamCreationScreen(
                                          fantasyMatch: match,
                                        ),
                                  ),
                                );
                              },
                              child: const Text('Create Team'),
                            ),
                          if (alreadyJoined)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'You have already created a team for this match!',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // User's Match History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Match History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<FantasyTeamModel>>(
                  future: _userHistoryFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No match history.'),
                      );
                    }
                    // Group by fantasyMatchId to avoid duplicate matches
                    final teams = snapshot.data!;
                    final uniqueMatches = <String, FantasyTeamModel>{};
                    for (var team in teams) {
                      uniqueMatches[team.fantasyMatchId] = team;
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          uniqueMatches.values.map((teamModel) {
                            final match = teamModel.fantasyMatch;
                            final homeTeam = match?.homeTeam;
                            final opponentTeam = match?.opponentTeam;
                            final matchInfo =
                                homeTeam != null && homeTeam.matches.isNotEmpty
                                    ? homeTeam.matches[0]
                                    : null;
                            return Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/dummy.png',
                                          width: 32,
                                          height: 32,
                                        ),
                                        Text(
                                          homeTeam?.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'vs',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/dummy.png',
                                          width: 32,
                                          height: 32,
                                        ),
                                        Text(
                                          opponentTeam?.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date: ${matchInfo != null ? matchInfo['date'] ?? 'Today' : 'Today'}',
                                    ),
                                    Text(
                                      'Venue: ${matchInfo != null ? matchInfo['venue'] ?? '-' : '-'}',
                                    ),
                                    Text('Your Points: ${teamModel.points}'),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            // Fetch all players for this match
                                            final response = await http.get(
                                              Uri.parse(
                                                '${ApiConfig.baseUrl}/fantasy/players-for-fantasy-match/${teamModel.fantasyMatchId}',
                                              ),
                                            );
                                            if (response.statusCode == 200) {
                                              final List data = json.decode(
                                                response.body,
                                              );
                                              final players =
                                                  (data
                                                          .map(
                                                            (e) =>
                                                                PlayerModel.fromJson(
                                                                  e,
                                                                ),
                                                          )
                                                          .toList()
                                                      as List<PlayerModel>);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => PlayerListScreen(
                                                        players: players,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('View Players'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Fetch user's team player details
                                            final response = await http.get(
                                              Uri.parse(
                                                '${ApiConfig.baseUrl}/fantasy/players-for-fantasy-match/${teamModel.fantasyMatchId}',
                                              ),
                                            );
                                            if (response.statusCode == 200) {
                                              final List data = json.decode(
                                                response.body,
                                              );
                                              final allPlayers =
                                                  (data
                                                          .map(
                                                            (e) =>
                                                                PlayerModel.fromJson(
                                                                  e,
                                                                ),
                                                          )
                                                          .toList()
                                                      as List<PlayerModel>);
                                              final myPlayers =
                                                  (allPlayers
                                                          .where(
                                                            (p) => teamModel
                                                                .players
                                                                .contains(p.id),
                                                          )
                                                          .toList()
                                                      as List<PlayerModel>);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => MyTeamScreen(
                                                        myPlayers: myPlayers,
                                                        captainId:
                                                            teamModel.captain,
                                                        viceCaptainId:
                                                            teamModel
                                                                .viceCaptain,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('My Team'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (match != null &&
                                      homeTeam != null &&
                                      opponentTeam != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MatchDetailScreen(
                                              fantasyMatch: match,
                                              team: homeTeam,
                                              matchInfo:
                                                  matchInfo != null
                                                      ? MatchModel.fromJson(
                                                        matchInfo,
                                                      )
                                                      : null,
                                            ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

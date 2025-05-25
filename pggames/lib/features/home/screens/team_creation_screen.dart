import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/fantasy_match_model.dart';
import '../../../models/player_model.dart';
import '../../../models/team_model.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/api_config.dart';

class TeamCreationScreen extends StatefulWidget {
  final FantasyMatchModel fantasyMatch;
  const TeamCreationScreen({super.key, required this.fantasyMatch});

  @override
  State<TeamCreationScreen> createState() => _TeamCreationScreenState();
}

class _TeamCreationScreenState extends State<TeamCreationScreen> {
  late Future<List<PlayerModel>> _playersFuture;
  final List<String> _selectedPlayerIds = [];
  String? _captainId;
  String? _viceCaptainId;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _playersFuture = fetchPlayers();
  }

  Future<List<PlayerModel>> fetchPlayers() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/fantasy/players-for-fantasy-match/${widget.fantasyMatch.id}',
      ),
    );
    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => PlayerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }

  void _togglePlayer(String playerId) {
    setState(() {
      if (_selectedPlayerIds.contains(playerId)) {
        _selectedPlayerIds.remove(playerId);
        if (_captainId == playerId) _captainId = null;
        if (_viceCaptainId == playerId) _viceCaptainId = null;
      } else {
        if (_selectedPlayerIds.length < 11) {
          _selectedPlayerIds.add(playerId);
        }
      }
    });
  }

  void _submitTeam() async {
    if (_selectedPlayerIds.length != 11 ||
        _captainId == null ||
        _viceCaptainId == null ||
        _captainId == _viceCaptainId) {
      setState(() {
        _error = 'Select 11 players, a captain, and a different vice-captain.';
      });
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final userId = await AuthService.getUserId();
    if (userId == null) {
      setState(() {
        _submitting = false;
        _error = 'User not logged in.';
      });
      return;
    }
    final response = await http.post(
      Uri.parse(ApiConfig.baseUrl + '/fantasy/team'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'fantasyMatchId': widget.fantasyMatch.id,
        'players': _selectedPlayerIds,
        'captain': _captainId,
        'viceCaptain': _viceCaptainId,
      }),
    );
    setState(() {
      _submitting = false;
    });
    if (response.statusCode == 200) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Team submitted! 49 rupees deducted.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } else {
      setState(() {
        _error = 'Failed to submit team: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Team'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<PlayerModel>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No players found.'));
          }
          final players = snapshot.data!;
          // Group players by role and then by team
          final Map<String, Map<String, List<PlayerModel>>> grouped = {};
          for (var player in players) {
            final role = player.role;
            final team = player.team;
            grouped.putIfAbsent(role, () => {});
            grouped[role]!.putIfAbsent(team, () => []);
            grouped[role]![team]!.add(player);
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      grouped.entries.map((roleEntry) {
                        final role = roleEntry.key;
                        final teams = roleEntry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: Text(
                                role,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ...teams.entries.map((teamEntry) {
                              final teamId = teamEntry.key;
                              final teamPlayers = teamEntry.value;
                              // Try to get team name from widget.fantasyMatch.homeTeam/opponentTeam
                              String teamName = '';
                              if (widget.fantasyMatch.homeTeam?.id == teamId) {
                                teamName =
                                    widget.fantasyMatch.homeTeam?.name ?? '';
                              } else if (widget.fantasyMatch.opponentTeam?.id ==
                                  teamId) {
                                teamName =
                                    widget.fantasyMatch.opponentTeam?.name ??
                                    '';
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      teamName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  ...teamPlayers.map((player) {
                                    final selected = _selectedPlayerIds
                                        .contains(player.id);
                                    return ListTile(
                                      leading: Image.asset(
                                        'assets/images/dummy.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                      title: Text(player.name),
                                      subtitle: Text(
                                        'Points: ${player.points}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (selected)
                                            DropdownButton<String>(
                                              value:
                                                  _captainId == player.id
                                                      ? 'Captain'
                                                      : _viceCaptainId ==
                                                          player.id
                                                      ? 'Vice-Captain'
                                                      : 'Player',
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Player',
                                                  child: Text('Player'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Captain',
                                                  child: Text('Captain'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Vice-Captain',
                                                  child: Text('Vice-Captain'),
                                                ),
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  if (val == 'Captain') {
                                                    _captainId = player.id;
                                                    if (_viceCaptainId ==
                                                        player.id) {
                                                      _viceCaptainId = null;
                                                    }
                                                  } else if (val ==
                                                      'Vice-Captain') {
                                                    _viceCaptainId = player.id;
                                                    if (_captainId ==
                                                        player.id) {
                                                      _captainId = null;
                                                    }
                                                  } else {
                                                    if (_captainId ==
                                                        player.id) {
                                                      _captainId = null;
                                                    }
                                                    if (_viceCaptainId ==
                                                        player.id) {
                                                      _viceCaptainId = null;
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          Checkbox(
                                            value: selected,
                                            onChanged:
                                                (_) => _togglePlayer(player.id),
                                          ),
                                        ],
                                      ),
                                      onTap: () => _togglePlayer(player.id),
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submitTeam,
                  child:
                      _submitting
                          ? const CircularProgressIndicator()
                          : const Text('Submit Team'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

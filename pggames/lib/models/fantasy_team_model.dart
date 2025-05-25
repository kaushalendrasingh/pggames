import 'fantasy_match_model.dart';

class FantasyTeamModel {
  final String id;
  final String userId;
  final String fantasyMatchId;
  final FantasyMatchModel? fantasyMatch;
  final List<String> players;
  final String captain;
  final String viceCaptain;
  final int points;

  FantasyTeamModel({
    required this.id,
    required this.userId,
    required this.fantasyMatchId,
    this.fantasyMatch,
    required this.players,
    required this.captain,
    required this.viceCaptain,
    required this.points,
  });

  factory FantasyTeamModel.fromJson(Map<String, dynamic> json) =>
      FantasyTeamModel(
        id: json['_id'] ?? '',
        userId: json['user'] ?? '',
        fantasyMatchId:
            json['fantasyMatch'] is String
                ? json['fantasyMatch']
                : (json['fantasyMatch']?['_id'] ?? ''),
        fantasyMatch:
            json['fantasyMatch'] is Map
                ? FantasyMatchModel.fromJson(json['fantasyMatch'])
                : null,
        players:
            (json['players'] as List?)?.map((e) => e.toString()).toList() ?? [],
        captain: json['captain'] ?? '',
        viceCaptain: json['viceCaptain'] ?? '',
        points: json['points'] ?? 0,
      );
}

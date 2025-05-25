import 'team_model.dart';

class FantasyMatchModel {
  final String id;
  final int entryFee;
  final bool isActive;
  final List<String> winners;
  final TeamModel? team; // legacy, for backward compatibility
  final TeamModel? homeTeam;
  final TeamModel? opponentTeam;
  final DateTime? startTime;

  FantasyMatchModel({
    required this.id,
    required this.entryFee,
    required this.isActive,
    required this.winners,
    this.team,
    this.homeTeam,
    this.opponentTeam,
    this.startTime,
  });

  factory FantasyMatchModel.fromJson(
    Map<String, dynamic> json,
  ) => FantasyMatchModel(
    id: json['_id'] ?? '',
    entryFee: json['entryFee'] ?? 0,
    isActive: json['isActive'] ?? false,
    winners:
        (json['winners'] as List?)?.map((e) => e.toString()).toList() ?? [],
    team: json['matchId'] != null ? TeamModel.fromJson(json['matchId']) : null,
    homeTeam:
        json['homeTeam'] != null ? TeamModel.fromJson(json['homeTeam']) : null,
    opponentTeam:
        json['opponentTeam'] != null
            ? TeamModel.fromJson(json['opponentTeam'])
            : null,
    startTime:
        json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
  );
}

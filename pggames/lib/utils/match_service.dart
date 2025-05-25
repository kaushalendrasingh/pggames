import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fantasy_match_model.dart';
import '../models/fantasy_team_model.dart';
import 'api_config.dart';

class MatchService {
  static String get baseUrl => ApiConfig.baseUrl + '/fantasy';

  // Fetch today's and upcoming matches
  static Future<List<FantasyMatchModel>> fetchTodayAndUpcomingMatches() async {
    final response = await http.get(Uri.parse(baseUrl + '/matches/today'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => FantasyMatchModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load matches');
    }
  }

  // Fetch user's match history
  static Future<List<FantasyTeamModel>> fetchUserMatchHistory(
    String userId,
  ) async {
    final response = await http.get(Uri.parse(baseUrl + '/my-matches/$userId'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => FantasyTeamModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user match history');
    }
  }
}

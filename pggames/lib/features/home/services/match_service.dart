import '../../../utils/api_client.dart';
import 'dart:convert';

class MatchService {
  Future<List<dynamic>> fetchMatches(context) async {
    final response = await ApiClient.get('fantasy/matches', context: context);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }
}

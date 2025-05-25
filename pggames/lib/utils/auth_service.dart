import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl + '/auth';

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      if (token != null) {
        final payload = _parseJwt(token);
        final userId = payload['id'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userId);
        return true;
      }
    }
    return false;
  }

  static Future<bool> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['token'];
      if (token != null) {
        final payload = _parseJwt(token);
        final userId = payload['id'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userId);
        return true;
      }
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload = base64Url.normalize(parts[1]);
    final payloadMap = json.decode(utf8.decode(base64Url.decode(payload)));
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }
}

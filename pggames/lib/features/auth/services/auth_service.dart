import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3010/api/';

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('${baseUrl}auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return null;
    } else {
      final data = json.decode(response.body);
      return data['message'] ?? 'Login failed';
    }
  }

  Future<dynamic> signup(String username, String email, String password) async {
    final url = Uri.parse('${baseUrl}auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );
    final data = json.decode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return data; // Return the whole response, including token
    } else {
      return data['message'] ?? 'Signup failed';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

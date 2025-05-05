import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiClient {
  static const String baseUrl =
      'http://10.0.2.2:3010/api/'; // Use 10.0.2.2 for Android emulator

  static Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    BuildContext? context,
  }) async {
    return _sendRequest('GET', path, headers: headers, context: context);
  }

  static Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    BuildContext? context,
  }) async {
    return _sendRequest(
      'POST',
      path,
      headers: headers,
      body: body,
      context: context,
    );
  }

  static Future<http.Response> _sendRequest(
    String method,
    String path, {
    Map<String, String>? headers,
    Object? body,
    BuildContext? context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse(baseUrl + path);
    final allHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: allHeaders);
          break;
        case 'POST':
          response = await http.post(uri, headers: allHeaders, body: body);
          break;
        case 'PUT':
          response = await http.put(uri, headers: allHeaders, body: body);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: allHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method');
      }
      if (response.statusCode == 401) {
        // Token expired or invalid, clear token and redirect to login
        await prefs.remove('token');
        if (context != null) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

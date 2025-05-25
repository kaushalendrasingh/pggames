import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallet_model.dart';
import 'api_config.dart';

class WalletService {
  static Future<WalletModel> fetchWallet(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/auth/wallet/$userId'),
    );
    if (response.statusCode == 200) {
      return WalletModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load wallet info');
    }
  }
}

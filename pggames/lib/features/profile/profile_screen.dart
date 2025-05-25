import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/auth_service.dart';
import '../../utils/wallet_service.dart';
import '../../models/wallet_model.dart';
import '../../utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  WalletModel? wallet;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final token = prefs.getString('token');
      if (userId == null || token == null) {
        setState(() {
          _error = 'User not logged in.';
          _loading = false;
        });
        return;
      }
      // Fetch user details
      final userRes = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/profile/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (userRes.statusCode == 200) {
        final userData = json.decode(userRes.body);
        username = userData['username'] ?? '';
        email = userData['email'] ?? '';
      }
      // Fetch wallet
      wallet = await WalletService.fetchWallet(userId);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile.';
        _loading = false;
      });
    }
  }

  void _changePassword() async {
    // TODO: Implement password change dialog and API call
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Change Password'),
            content: const Text('Password change feature coming soon.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Username: $username'),
                    Text('Email: $email'),
                    if (wallet != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Wallet: ₹${wallet!.total} (Withdrawable: ₹${wallet!.withdrawable}, Bonus: ₹${wallet!.nonWithdrawable})',
                      ),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _changePassword,
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
    );
  }
}

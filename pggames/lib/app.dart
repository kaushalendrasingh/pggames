import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/wallet_screen.dart';
import 'features/home/screens/my_matches_screen.dart';
import 'features/home/screens/settings_screen.dart';
import 'models/wallet_model.dart';
import 'utils/auth_service.dart';
import 'utils/wallet_service.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  WalletModel? _wallet;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndWallet();
  }

  Future<void> _loadUserAndWallet() async {
    final userId = await AuthService.getUserId();
    if (userId != null) {
      final wallet = await WalletService.fetchWallet(userId);
      setState(() {
        _userId = userId;
        _wallet = wallet;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [HomeScreen(), MyMatchesScreen(), SettingsScreen()];
    return Scaffold(
      appBar: AppBar(
        title: const Text('PG Games'),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (_wallet != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WalletScreen(wallet: _wallet!),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${_wallet!.total}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../models/wallet_model.dart';

class WalletScreen extends StatelessWidget {
  final WalletModel wallet;
  const WalletScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance: ₹${wallet.total}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Withdrawable: ₹${wallet.withdrawable}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Bonus (Non-Withdrawable): ₹${wallet.nonWithdrawable}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add money flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Money coming soon!')),
                );
              },
              child: const Text('Add Money'),
            ),
          ],
        ),
      ),
    );
  }
}

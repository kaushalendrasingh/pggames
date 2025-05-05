import 'package:flutter/material.dart';

class ComingSoonBanner extends StatelessWidget {
  const ComingSoonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.celebration, color: Colors.orange, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Coming Soon: Ludo, Rummy, and more exciting games!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

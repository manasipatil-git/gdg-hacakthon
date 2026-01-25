import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/log');
            },
            child: const Text('⚡ Quick Log'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/challenges');
            },
            child: const Text('🎯 Challenges'),
          ),
        ),
      ],
    );
  }
}

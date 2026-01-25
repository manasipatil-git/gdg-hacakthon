import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ActiveChallengeCard extends StatelessWidget {
  const ActiveChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Challenge',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('7-Day Walk Challenge'),
              SizedBox(height: 8),
              LinearProgressIndicator(value: 5 / 7),
              SizedBox(height: 8),
              Text('5 / 7 days • ⭐ 200 pts'),
            ],
          ),
        ),
      ],
    );
  }
}

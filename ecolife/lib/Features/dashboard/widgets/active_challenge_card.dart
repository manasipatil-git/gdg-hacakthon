import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ActiveChallengeCard extends StatelessWidget {
  const ActiveChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Active Challenge',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Bike Champion'),
          SizedBox(height: 4),
          LinearProgressIndicator(value: 0.3),
          SizedBox(height: 6),
          Text('5 / 14 days • 500 pts'),
        ],
      ),
    );
  }
}

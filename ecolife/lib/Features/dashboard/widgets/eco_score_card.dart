import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class EcoScoreCard extends StatelessWidget {
  final int score;
  final int streakDays;

  const EcoScoreCard({
    super.key,
    required this.score,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Eco Score 🌱'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('🔥 $streakDays day streak'),
          ),
        ],
      ),
    );
  }
}

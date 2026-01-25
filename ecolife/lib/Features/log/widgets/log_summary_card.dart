import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LogSummaryCard extends StatelessWidget {
  final int score;

  const LogSummaryCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Text(
            'Eco Score Earned',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '+$score',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

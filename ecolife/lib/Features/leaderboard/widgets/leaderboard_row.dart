import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final bool isYou;

  const LeaderboardRow({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isYou ? AppColors.primary : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isYou
            ? AppColors.primary.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isYou
              ? AppColors.primary.withOpacity(0.25)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔢 Rank
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: accent,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // 👤 Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // 📛 Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? '$name (You)' : name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                if (isYou)
                  const SizedBox(height: 2),
                if (isYou)
                  Text(
                    '🔥 You’re on the board',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),

          // 🌱 Score
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$score pts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class StreakWidget extends StatelessWidget {
  final List<bool> last7Days; // true = logged

  const StreakWidget({super.key, required this.last7Days});

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
        children: [
          const Text(
            '🔥 Streak',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return CircleAvatar(
                radius: 16,
                backgroundColor:
                    last7Days[index] ? AppColors.primary : Colors.grey[300],
                child: last7Days[index]
                    ? const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 18)
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}

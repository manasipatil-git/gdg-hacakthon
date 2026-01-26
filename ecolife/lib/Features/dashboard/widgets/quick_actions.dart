import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔥 Same as Yesterday (SAFE & WORKING)
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              // Navigate to log screen where logic already exists
              Navigator.pushNamed(
                context,
                '/log',
                arguments: {'useYesterday': true},
              );
            },
            icon: const Icon(Icons.history),
            label: const Text(
              'Same as yesterday',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 🎯 Challenges (emoji restored)
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/challenges');
            },
            child: Text(
              '🎯 Challenges',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

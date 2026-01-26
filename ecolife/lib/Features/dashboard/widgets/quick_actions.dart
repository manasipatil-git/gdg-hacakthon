import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/log');
            },
            child: const Text(
              '⚡ Quick Log',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        const SizedBox(width: 12),

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
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

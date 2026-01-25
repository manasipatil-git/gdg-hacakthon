import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ImpactCard extends StatelessWidget {
  const ImpactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.flash_on),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You saved enough CO₂ today to power a ceiling fan for 10 hours!',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LogProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const LogProgressBar({
    super.key,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$step of $total',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: step / total,
            minHeight: 10,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

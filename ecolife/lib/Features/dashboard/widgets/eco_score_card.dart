import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class EcoScoreCard extends StatelessWidget {
  final int score;
  final int streakDays;
  final bool isLoading;

  /// dailyTarget can later come from backend / config
  final int dailyTarget;

  const EcoScoreCard({
    super.key,
    required this.score,
    required this.streakDays,
    this.isLoading = false,
    this.dailyTarget = 300, // logical cap, not UI hardcoding
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        (score / dailyTarget).clamp(0.0, 1.0); // 0 → 1

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7E8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // 🔵 Circular Progress
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(90, 90),
                        painter: _EcoProgressPainter(progress),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            score.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '/ $dailyTarget',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // 🌱 Text + Streak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eco Score 🌱',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(progress * 100).round()}% of today’s goal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🔥 $streakDays day streak',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// 🎨 Custom circular painter (NO packages)
class _EcoProgressPainter extends CustomPainter {
  final double progress;

  _EcoProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final backgroundPaint = Paint()
      ..color = Colors.green.withOpacity(0.15)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // background ring
    canvas.drawCircle(center, radius, backgroundPaint);

    // progress arc
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

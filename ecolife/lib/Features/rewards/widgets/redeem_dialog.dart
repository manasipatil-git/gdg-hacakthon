import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/reward_items.dart';
import '../../../core/constants/colors.dart';

class RedeemDialog extends StatelessWidget {
  final RewardItem item;
  final VoidCallback onConfirm;

  const RedeemDialog({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.85,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.grey.shade600,
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),

              const SizedBox(height: 4),

              // Title
              const Text(
                'Redeem Reward',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                'Show this QR code at the counter',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // QR Code with Item Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dummy QR Code
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomPaint(
                        painter: DummyQRPainter(emoji: item.emoji),
                        size: const Size(200, 200),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Item Details
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  item.location,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.remove_circle_outline,
                                  size: 16,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${item.cost} points',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm Redemption',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dummy QR code
class DummyQRPainter extends CustomPainter {
  final String emoji;

  DummyQRPainter({required this.emoji});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final blockSize = size.width / 12;
    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw random QR-like pattern
    for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 12; j++) {
        // Skip center area for emoji
        if (i >= 4 && i <= 7 && j >= 4 && j <= 7) {
          continue;
        }

        // Skip corner markers
        if ((i < 3 && j < 3) || 
            (i < 3 && j > 8) || 
            (i > 8 && j < 3)) {
          continue;
        }

        if (random.nextBool()) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                j * blockSize + 1,
                i * blockSize + 1,
                blockSize - 2,
                blockSize - 2,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }

    // Draw three corner markers (typical QR code style)
    _drawCornerMarker(canvas, 0, 0, blockSize);
    _drawCornerMarker(canvas, 0, 9 * blockSize, blockSize);
    _drawCornerMarker(canvas, 9 * blockSize, 0, blockSize);

    // Draw center emoji container
    final centerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        4 * blockSize,
        4 * blockSize,
        4 * blockSize,
        4 * blockSize,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(
      centerRect,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill,
    );

    // Draw emoji text
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(fontSize: 32),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  void _drawCornerMarker(Canvas canvas, double x, double y, double blockSize) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = blockSize * 0.15;

    // Outer square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, blockSize * 3, blockSize * 3),
        const Radius.circular(4),
      ),
      paint,
    );

    // Inner square (filled)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x + blockSize,
          y + blockSize,
          blockSize,
          blockSize,
        ),
        const Radius.circular(2),
      ),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
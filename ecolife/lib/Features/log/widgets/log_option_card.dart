import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Duration for option tile selection animation.
const _kTileAnimationDuration = Duration(milliseconds: 220);

class LogOptionTile extends StatelessWidget {
  final String text;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  /// Optional category accent; when set, selected state uses this color.
  final Color? categoryColor;

  const LogOptionTile({
    super.key,
    required this.text,
    this.emoji,
    required this.selected,
    required this.onTap,
    this.categoryColor,
  });

  Color get _accent => categoryColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: reducedMotion ? Duration.zero : _kTileAnimationDuration,
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected ? _accent.withOpacity(0.12) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _accent.withOpacity(0.7) : Colors.grey.shade300,
            width: selected ? 2 : 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accent.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selected ? _accent : AppColors.textDark,
                ),
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: _accent, size: 24),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../data/reward_items.dart';
import '../../../core/constants/colors.dart';

class RewardItemCard extends StatelessWidget {
  final RewardItem item;
  final int userScore;
  final VoidCallback onRedeem;

  const RewardItemCard({
    super.key,
    required this.item,
    required this.userScore,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canRedeem = userScore >= item.cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.emoji} ${item.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(item.location),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: canRedeem ? onRedeem : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text('Redeem • ${item.cost}'),
          ),
        ],
      ),
    );
  }
}

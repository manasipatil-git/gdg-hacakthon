import 'package:flutter/material.dart';
import '../widgets/reward_item_card.dart';
import '../widgets/redeem_dialog.dart';
import '../data/reward_items.dart';
import '../services/rewards_service.dart';
import '../../../core/constants/colors.dart';

class RewardsTab extends StatelessWidget {
  final int userScore;
  final String uid;

  const RewardsTab({
    super.key,
    required this.userScore,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    // Group rewards by category
    final groupedRewards = <String, List<RewardItem>>{};
    for (var item in rewardItems) {
      if (!groupedRewards.containsKey(item.category)) {
        groupedRewards[item.category] = [];
      }
      groupedRewards[item.category]!.add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Categories
        ...groupedRewards.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              // Items in category
              ...entry.value.map((item) {
                return RewardItemCard(
                  item: item,
                  userScore: userScore,
                  onTap: () => _handleRewardTap(context, item),
                );
              }),
              
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  void _handleRewardTap(BuildContext context, RewardItem item) {
    // Check if user has enough points
    if (userScore < item.cost) {
      final shortage = item.cost - userScore;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('You need $shortage more points!'),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Show redeem dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RedeemDialog(
        item: item,
        onConfirm: () => _handleRedeem(context, item),
      ),
    );
  }

  Future<void> _handleRedeem(BuildContext context, RewardItem item) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      // Redeem the reward
      await RewardsService().redeemReward(
        uid: uid,
        itemId: item.id,
        itemName: item.name,
        itemEmoji: item.emoji,
        cost: item.cost,
        location: item.location,
      );

      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);
        // Close redeem dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${item.emoji} ${item.name} Redeemed!',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '-${item.cost} points • Show at ${item.location}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
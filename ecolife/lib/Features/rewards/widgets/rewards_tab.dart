import 'package:flutter/material.dart';
import '../widgets/reward_item_card.dart';
import '../widgets/redeem_dialog.dart';
import '../data/reward_items.dart';
import '../../../core/services/firestore_service.dart';
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
      groupedRewards.putIfAbsent(item.category, () => []);
      groupedRewards[item.category]!.add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...groupedRewards.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    if (userScore < item.cost) {
      final shortage = item.cost - userScore;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need $shortage more points!'),
          backgroundColor: Colors.orange.shade700,
        ),
      );
      return;
    }

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
      // Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      // 🔥 CORRECT CALL (FirestoreService)
      await FirestoreService().redeemReward(
        uid: uid,
        pointsRequired: item.cost,
        rewardId: item.id,
        rewardName: item.name,
      );

      if (!context.mounted) return;

      Navigator.pop(context); // loading
      Navigator.pop(context); // redeem dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.emoji} ${item.name} redeemed (-${item.cost} pts)',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      Navigator.pop(context); // loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
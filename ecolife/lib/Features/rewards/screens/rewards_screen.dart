import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/eco_score_card.dart';
import '../widgets/reward_item_card.dart';
import '../data/reward_items.dart';
import '../../../core/providers/user_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final int userEcoScore = user?.ecoScore ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            EcoScoreCard(
              score: userEcoScore,
            ),
            const SizedBox(height: 24),

            ...rewardItems.map(
              (item) => RewardItemCard(
                item: item,
                userScore: userEcoScore,
                onRedeem: () {
                  // redeem logic later
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

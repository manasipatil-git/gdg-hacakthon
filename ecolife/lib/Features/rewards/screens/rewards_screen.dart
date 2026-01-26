import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/eco_score_card.dart';
import '../widgets/reward_item_card.dart';
import '../data/reward_items.dart';
import '../../../core/services/firestore_service.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder(
      stream: FirestoreService().userStream(uid),
      builder: (context, snapshot) {
        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Error
        if (!snapshot.hasData || snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Failed to load rewards')),
          );
        }

        final user = snapshot.data!;
        final int userEcoScore = user.ecoScore;

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
      },
    );
  }
}

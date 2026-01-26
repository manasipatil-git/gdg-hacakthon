import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/colors.dart';
import '../data/challenge_definitions.dart';

class ActiveChallengeCard extends StatelessWidget {
  const ActiveChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('challenges')
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(); // no active challenge
        }

        final doc = snapshot.data!.docs.first;
        final challengeId = doc.id;
        final progress = doc['progress'];

        // 🔥 get challenge definition from app
        final challenge = challengeDefinitions
            .firstWhere((c) => c.id == challengeId);

        final progressPercent =
            progress / challenge.daysRequired;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(challenge.description),
              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  backgroundColor: AppColors.background,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$progress / ${challenge.daysRequired} days',
                  ),
                  Text(
                    '${challenge.reward} pts',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

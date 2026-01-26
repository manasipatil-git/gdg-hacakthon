import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/colors.dart';

class ActiveChallengeCard extends StatelessWidget {
  const ActiveChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        if (!data.containsKey('activeChallenge')) {
          return const SizedBox(); // no active challenge
        }

        final activeChallenge =
            data['activeChallenge'] as Map<String, dynamic>;

        final progress = activeChallenge['progress'] ?? 0;
        final reward = activeChallenge['reward'] ?? 0;
        final title = activeChallenge['title'] ?? '';
        final description = activeChallenge['description'] ?? '';
        final difficulty = activeChallenge['difficulty'] ?? '';

        // Optional: if you later add totalDays
        final int totalDays =
            activeChallenge['totalDays'] ?? 7; // fallback

        final progressPercent =
            totalDays > 0 ? progress / totalDays : 0.0;

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
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(description),
              const SizedBox(height: 6),
              Text(
                difficulty,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercent.clamp(0.0, 1.0),
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
                  Text('$progress / $totalDays days'),
                  Text(
                    '$reward pts',
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

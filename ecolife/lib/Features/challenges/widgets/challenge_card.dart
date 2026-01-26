import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/challenge_model.dart';
import '../../../core/constants/colors.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const ChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
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
            challenge.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(challenge.description),
          const SizedBox(height: 8),
          Text(
            '${challenge.reward} EcoScore • ${challenge.difficulty}',
          ),
          const SizedBox(height: 12),

          /// ✅ ACCEPT CHALLENGE (SINGLE SOURCE OF TRUTH)
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set({
                'activeChallenge': {
                  'id': challenge.id,
                  'title': challenge.title,
                  'description': challenge.description,
                  'reward': challenge.reward,
                  'difficulty': challenge.difficulty,
                  'progress': 0,
                  'totalDays': challenge.daysRequired,
                  'status': 'active',
                  'startedAt': FieldValue.serverTimestamp(),
                }
              }, SetOptions(merge: true));

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Challenge activated 🎯'),
                ),
              );

              // Optional UX: go back to dashboard
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('Accept Challenge'),
          ),
        ],
      ),
    );
  }
}

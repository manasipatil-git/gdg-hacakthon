import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../../../core/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          Text(challenge.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(challenge.description),
          const SizedBox(height: 8),
          Text('${challenge.reward} EcoScore • ${challenge.difficulty}'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('challenges')
                  .doc(challenge.id)
                  .set({
                'status': 'active',
                'progress': 0,
                'startedAt': Timestamp.now(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Challenge Activated')),
              );
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/colors.dart';

class LeaderboardPreview extends StatelessWidget {
  const LeaderboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('ecoScore', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No leaderboard data yet');
        }

        final users = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/leaderboard');
                  },
                  child: const Text('View All →'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Leaderboard rows
            ...List.generate(users.length, (index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;
              final isYou = doc.id == uid;
              final rank = index + 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isYou
                      ? const Color(0xFFE8FFF4)
                      : rank == 1
                          ? const Color(0xFFFFF3DC)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // 🏆 Rank / Crown
                    rank == 1
                        ? const Icon(Icons.emoji_events,
                            color: Colors.amber)
                        : Text(
                            '$rank',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                    const SizedBox(width: 12),

                    // 👤 Avatar
                    CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withOpacity(0.2),
                      child: Text(
                        (data['name'] ?? 'U')[0].toUpperCase(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 📛 Name + streak
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isYou
                                ? '${data['name']} (You)'
                                : data['name'] ?? 'User',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '🔥 ${data['streak'] ?? 0} day streak',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🌱 Score
                    Text(
                      '${data['ecoScore'] ?? 0} pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

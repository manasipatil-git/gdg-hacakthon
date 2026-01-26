import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/leaderboard_service.dart';
import '../widgets/top_three_podium.dart';
import '../widgets/leaderboard_row.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = LeaderboardService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Leaderboard'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: service.getLeaderboard(),
        builder: (context, snapshot) {
          // 🔴 HANDLE ERRORS (prevents infinite loader)
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load leaderboard.\nPlease try again later.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // ⏳ LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🧾 NO DATA
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leaderboard data yet'));
          }

          final users = snapshot.data!;

          final topThree =
              users.length >= 3 ? users.take(3).toList() : users;

          final remainingUsers =
              users.length > 3 ? users.sublist(3) : [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🏆 Top podium
                TopThreePodium(users: topThree),

                const SizedBox(height: 24),

                // 📋 Remaining ranks
                if (remainingUsers.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: remainingUsers.length,
                    itemBuilder: (context, index) {
                      final user = remainingUsers[index];
                      final rank = index + 4;

                      return LeaderboardRow(
                        rank: rank,
                        name: user['name'],
                        score: user['ecoScore'],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

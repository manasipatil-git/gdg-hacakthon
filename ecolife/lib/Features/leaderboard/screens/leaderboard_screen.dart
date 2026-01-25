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
      body: StreamBuilder(
        stream: service.getLeaderboard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text('No data yet'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TopThreePodium(users: users.take(3).toList()),
                const SizedBox(height: 24),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length - 3,
                  itemBuilder: (context, index) {
                    final user = users[index + 3];
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

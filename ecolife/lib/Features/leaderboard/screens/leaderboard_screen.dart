import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/leaderboard_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedFilter = 'Individual';

  // Accent colors from the palette
  final Color farmGreen = const Color(0xFF165F47);
  final Color lettuce = const Color(0xFF2DA669);
  final Color lemonGreen = const Color(0xFFAED160);
  final Color lightGreen = const Color(0xFFE3EA98);
  final Color lemon = const Color(0xFFFFEC17);
  final Color pumpkin = const Color(0xFFF2923B);
  final Color chiliPapper = const Color(0xFFB91F3F);
  final Color beetroot = const Color(0xFF8C4074);

  @override
  Widget build(BuildContext context) {
    final service = LeaderboardService();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text('🏆', style: TextStyle(fontSize: 24)),
              ],
            ),
            Text(
              'See how you rank against others',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // 🔹 Filter tabs (College/Department/Individual)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(child: _filterTab('Individual')),
                const SizedBox(width: 12),
                Expanded(child: _filterTab('Department')),
                const SizedBox(width: 12),
                Expanded(child: _filterTab('College')),
              ],
            ),
          ),

          // 🔹 Stats cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: service.getLeaderboard(),
              builder: (context, snapshot) {
                int userRank = 0;
                int userScore = 0;
                int topScore = 0;

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final users = snapshot.data!;
                  topScore = users.first['ecoScore'] ?? 0;
                  
                  for (int i = 0; i < users.length; i++) {
                    if (users[i]['uid'] == uid) {
                      userRank = i + 1;
                      userScore = users[i]['ecoScore'] ?? 0;
                      break;
                    }
                  }
                }

                return Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: '🥇',
                        label: 'Top Spot',
                        value: '$topScore',
                        color: const Color(0xFFFFF3DC),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: '#$userRank',
                        label: 'Your Rank',
                        value: '',
                        color: const Color(0xFFE8FFF4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: '$userScore',
                        label: 'Points',
                        value: '',
                        color: const Color(0xFFFFE8E8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 📋 Leaderboard list
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: service.getLeaderboard(),
              builder: (context, snapshot) {
                // 🔴 HANDLE ERRORS
                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Unable to load leaderboard.\nPlease try again later.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // ⏳ LOADING STATE
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                // 🧾 NO DATA
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No leaderboard data yet'),
                    ),
                  );
                }

                final users = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final rank = index + 1;
                    final isYou = user['uid'] == uid;

                    // Get medal/icon for top 3
                    String rankDisplay = '$rank';
                    Color? rankBgColor;
                    
                    if (rank == 1) {
                      rankDisplay = '👑';
                      rankBgColor = const Color(0xFFFFF3DC);
                    } else if (rank == 2) {
                      rankDisplay = '🥈';
                      rankBgColor = const Color(0xFFE8E8E8);
                    } else if (rank == 3) {
                      rankDisplay = '🥉';
                      rankBgColor = const Color(0xFFFFE4CC);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isYou
                            ? const Color(0xFFE8FFF4)
                            : rank <= 3 
                                ? rankBgColor
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isYou
                            ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          // 🏅 Rank
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: rank <= 3 
                                  ? Colors.transparent
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              rankDisplay,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: rank <= 3 ? 20 : 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 👤 Avatar
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: _getAvatarColor(rank),
                            child: Text(
                              (user['name'] ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
                                      ? '${user['name']} (You)'
                                      : user['name'] ?? 'User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if (user['streak'] != null)
                                  Row(
                                    children: [
                                      const Text(
                                        '🔥',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${user['streak']} day streak',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // 🌱 Score
                          Text(
                            '${user['ecoScore'] ?? 0}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'points',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTab(String text) {
    final isSelected = selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int rank) {
    switch (rank % 8) {
      case 0:
        return farmGreen;
      case 1:
        return lettuce;
      case 2:
        return lemonGreen;
      case 3:
        return lemon;
      case 4:
        return pumpkin;
      case 5:
        return chiliPapper;
      case 6:
        return beetroot;
      default:
        return AppColors.primary;
    }
  }
}
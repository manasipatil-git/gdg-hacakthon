import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/firestore_service.dart';

// Dashboard widgets
import '../widgets/greeting_header.dart';
import '../widgets/eco_score_card.dart';
import '../widgets/impact_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/leaderboard_preview.dart';

// Challenges widget
import '../../challenges/widgets/active_challenge_card.dart';
import '../widgets/streak_calendar_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Error
        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Failed to load user data')),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: const DashboardBottomNav(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👋 Greeting
                  GreetingHeader(
                    name: user.name.isNotEmpty ? user.name : 'there',
                  ),

                  const SizedBox(height: 16),

                  // 🌱 Eco Score Card (LIVE)
                  EcoScoreCard(
                    score: user.ecoScore,
                    streakDays: user.streak,
                  ),

                  const SizedBox(height: 16),

                  // 🔥 Streak Calendar (reads from logs)
                  const StreakCalendarCard(),

                  const SizedBox(height: 16),

                  // ➕ Log Action CTA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/log');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Log an Eco Action',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ⚡ Impact
                  const ImpactCard(),

                  const SizedBox(height: 16),

                  // ⚡ Quick Actions
                  const QuickActions(),

                  const SizedBox(height: 24),

                  // 🎯 Active Challenge
                  const Text(
                    'Active Challenge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ActiveChallengeCard(),

                  const SizedBox(height: 24),

                  // 🏆 Leaderboard
                  const LeaderboardPreview(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ─────────────────────────────
/// Bottom Navigation
/// ─────────────────────────────
class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.muted,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/log');
            break;
          case 2:
            Navigator.pushNamed(context, '/leaderboard');
            break;
          case 3:
            Navigator.pushNamed(context, '/rewards');
            break;
          case 4:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Log'),
        BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events), label: 'Ranks'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard), label: 'Rewards'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

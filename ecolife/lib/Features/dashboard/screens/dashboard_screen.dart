import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/colors.dart';
import '../../../core/services/firestore_service.dart';

// Widgets
import '../widgets/greeting_header.dart';
import '../widgets/eco_score_card.dart';
import '../widgets/impact_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/active_challenge_card.dart';
import '../widgets/leaderboard_preview.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const DashboardBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Greeting Header (dynamic from Firestore)
              FutureBuilder<String>(
                future: FirestoreService().getUserName(uid),
                builder: (context, snapshot) {
                  final name = snapshot.hasData && snapshot.data!.isNotEmpty
                      ? snapshot.data!
                      : 'there';

                  return GreetingHeader(name: name);
                },
              ),

              const SizedBox(height: 16),

              /// 🔹 Eco score (TEMP static – backend wiring next)
              const EcoScoreCard(
                score: 78,
                streakDays: 5,
              ),

              const SizedBox(height: 12),

              /// 🔹 Impact card
              const ImpactCard(),

              const SizedBox(height: 16),

              /// 🔹 Quick actions
              const QuickActions(),

              const SizedBox(height: 24),

              /// 🔹 Active challenge
              const ActiveChallengeCard(),

              const SizedBox(height: 24),

              /// 🔹 Leaderboard preview
              const LeaderboardPreview(),

              const SizedBox(height: 32),

              /// 🔥 TEMP TEST BUTTON (REMOVE BEFORE FINAL SUBMISSION)
              ElevatedButton(
                onPressed: () async {
                  await FirestoreService().addTestTrip(uid);
                },
                child: const Text('Add Test Trip'),
              ),
            ],
          ),
        ),
      ),
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
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Ranks'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard), label: 'Rewards'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
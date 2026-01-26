import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/colors.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/firestore_service.dart';

// Dashboard widgets
import '../widgets/greeting_header.dart';
import '../widgets/eco_score_card.dart';
import '../widgets/impact_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/leaderboard_preview.dart';

// Challenges widget (ONLY ONE SOURCE OF TRUTH)
import '../../challenges/widgets/active_challenge_card.dart';
import '../widgets/streak_calendar_card.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final fetchedUser = await FirestoreService().fetchUser(uid);

    if (!mounted) return;

    context.read<UserProvider>().setUser(fetchedUser);
    setState(() {
      isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final demoActionUsed = userProvider.demoActionLoggedThisSession;

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
                name: user?.name.isNotEmpty == true ? user!.name : 'there',
              ),

              const SizedBox(height: 16),

              // 🌱 Eco Score Card (FULL WIDTH)
              if (isLoadingUser || user == null)
                const EcoScoreCard(
                  score: 0,
                  streakDays: 0,
                  isLoading: true,
                )
              else
                EcoScoreCard(
                  score: user.ecoScore,
                  streakDays: user.streak,
                ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),
             const StreakCalendarCard(),


              // 🚍 DEMO ECO ACTION (SESSION SAFE)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: demoActionUsed
                        ? Colors.grey.shade400
                        : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: (user == null || demoActionUsed)
                      ? null
                      : () async {
                          final uid =
                              FirebaseAuth.instance.currentUser!.uid;

                          // 1️⃣ Log demo trip
                          await FirestoreService().addTestTrip(uid);

                          // 2️⃣ Fetch updated user
                          final updatedUser =
                              await FirestoreService().fetchUser(uid);

                          if (!mounted) return;

                          // 3️⃣ Update provider state
                          context.read<UserProvider>().setUser(updatedUser);
                          context
                              .read<UserProvider>()
                              .markDemoActionLogged();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('🌱 Eco action logged for today'),
                            ),
                          );
                        },
                  child: Text(
                    demoActionUsed
                        ? '✅ Action logged for today'
                        : '🚍 Used Public Transport Today (Demo)',
                    style: const TextStyle(fontSize: 15),
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

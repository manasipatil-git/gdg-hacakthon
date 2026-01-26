import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../widgets/log_summary_card.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/firestore_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  int step = 1;
  int totalScore = 0;
  String? selected;
  bool showSummary = false;

  String? transport;
  String? food;
  String? energy;

  final transportOptions = const {
    'Public Transport': 5,
    'Bike': 3,
    'Car': 0,
  };

  final foodOptions = const {
    'Veg': 4,
    'Mixed Diet': 2,
    'Non-Veg': 0,
  };

  final energyOptions = const {
    'Fan': 3,
    'AC': 0,
  };

  Future<void> _submit(BuildContext context) async {
    final userProvider = context.read<UserProvider>();

    // 🔒 HARD STOP: already logged this session
    if (userProvider.demoActionLoggedThisSession) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ You have already logged today’s eco action'),
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 🔹 Use same backend logic as dashboard (single source of truth)
    await FirestoreService().addTestTrip(uid);

    // 🔹 Fetch updated user
    final updatedUser = await FirestoreService().fetchUser(uid);

    if (!mounted) return;

    // 🔹 Update Provider
    context.read<UserProvider>().setUser(updatedUser);
    context.read<UserProvider>().markDemoActionLogged();

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final demoActionUsed =
        context.watch<UserProvider>().demoActionLoggedThisSession;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: demoActionUsed
              ? _alreadyLoggedView(context)
              : showSummary
                  ? _summaryView(context)
                  : _logView(),
        ),
      ),
    );
  }

  /// 🔒 SHOWN IF ACTION ALREADY LOGGED
  Widget _alreadyLoggedView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 72, color: Colors.green),
        const SizedBox(height: 20),
        const Text(
          'Eco action already logged 🌱',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'You can log one eco action per session for this demo.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Back to Dashboard'),
          ),
        ),
      ],
    );
  }

  Widget _logView() {
    final options = step == 1
        ? transportOptions
        : step == 2
            ? foodOptions
            : energyOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LogProgressBar(step: step, total: 3),
        const SizedBox(height: 32),
        Text(
          step == 1
              ? 'How did you travel today?'
              : step == 2
                  ? 'What did you eat today?'
                  : 'Which appliance did you use most?',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 28),
        ...options.entries.map((e) {
          return LogOptionTile(
            text: e.key,
            selected: selected == e.key,
            onTap: () {
              setState(() {
                selected = e.key;
                totalScore += e.value;

                if (step == 1) transport = e.key;
                if (step == 2) food = e.key;
                if (step == 3) energy = e.key;
              });

              Future.delayed(const Duration(milliseconds: 250), () {
                if (!mounted) return;

                if (step == 3) {
                  setState(() => showSummary = true);
                } else {
                  setState(() {
                    step++;
                    selected = null;
                  });
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _summaryView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Today’s Impact 🌱',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        LogSummaryCard(score: totalScore),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => _submit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Finish',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}

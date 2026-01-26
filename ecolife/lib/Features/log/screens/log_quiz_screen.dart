import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../widgets/log_summary_card.dart';
import '../../../core/constants/colors.dart';
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
  bool isSubmitting = false;

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

  /// ✅ FIXED NAVIGATION WITH DEBUGGING
  Future<void> _submit() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    
    print('🔵 Starting submission...');
    print('🔵 UID: $uid');
    print('🔵 Total Score: $totalScore');

    if (uid == null) {
      print('🔴 ERROR: User not logged in');
      if (!mounted) return;
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in. Please sign in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (totalScore == 0) {
      print('⚠️ Warning: totalScore is 0');
    }

    try {
      print('🔵 Calling logEcoAction...');
      await FirestoreService().logEcoAction(
        uid: uid,
        points: totalScore,
        type: 'daily_log',
      );
      
      print('✅ logEcoAction completed successfully');

      if (!mounted) return;

      print('🔵 Navigating to dashboard...');
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
      print('✅ Navigation called');
    } catch (e, stackTrace) {
      print('🔴 ERROR in _submit: $e');
      print('🔴 Stack trace: $stackTrace');
      
      if (!mounted) return;
      
      setState(() => isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log action: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: showSummary ? _summaryView() : _logView(),
        ),
      ),
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

  Widget _summaryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Today\'s Impact 🌱',
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
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Finish',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
        ),
      ],
    );
  }
}
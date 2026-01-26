import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../widgets/log_summary_card.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/firestore_service.dart';
import '../controller/log_controller.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  int step = 1;
  String? selected;
  bool showSummary = false;
  bool isSubmitting = false;

  final LogController _controller = LogController();

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

  final waterOptions = const {
    'Normal Usage': 2,
    'Long Shower': 0,
  };

  // 🆕 Same as Yesterday (demo values)
  void _useYesterday() {
    _controller.addAnswer('transport', 'Public Transport', 5);
    _controller.addAnswer('food', 'Veg', 4);
    _controller.addAnswer('energy', 'Fan', 3);
    _controller.addAnswer('water', 'Normal Usage', 2);

    setState(() {
      showSummary = true;
    });
  }

  Future<void> _submit() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
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

    try {
      await FirestoreService().logEcoAction(
        uid: uid,
        points: _controller.score,
        type: 'daily_log',
      );

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log action: $e'),
          backgroundColor: Colors.red,
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
            : step == 3
                ? energyOptions
                : waterOptions;

    final answerKey = step == 1
        ? 'transport'
        : step == 2
            ? 'food'
            : step == 3
                ? 'energy'
                : 'water';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🆕 Live score preview
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Eco Score',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '+${_controller.score}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        // 🆕 Same as yesterday button
        GestureDetector(
          onTap: _useYesterday,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.9),
                  AppColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Same as yesterday',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        LogProgressBar(step: step, total: 4),
        const SizedBox(height: 32),
        Text(
          step == 1
              ? 'How did you travel today?'
              : step == 2
                  ? 'What did you eat today?'
                  : step == 3
                      ? 'Which appliance did you use most?'
                      : 'How was your water usage today?',
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
              _controller.addAnswer(answerKey, e.key, e.value);

              setState(() {
                selected = e.key;
              });

              Future.delayed(const Duration(milliseconds: 250), () {
                if (!mounted) return;

                if (step == 4) {
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
        LogSummaryCard(score: _controller.score),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
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

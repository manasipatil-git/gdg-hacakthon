import 'package:flutter/material.dart';
import '../controller/log_controller.dart';
import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../../../core/constants/colors.dart';

class LogQuizScreen extends StatefulWidget {
  const LogQuizScreen({super.key});

  @override
  State<LogQuizScreen> createState() => _LogQuizScreenState();
}

class _LogQuizScreenState extends State<LogQuizScreen> {
  final controller = LogController();
  int step = 1;
  String? selected;

  void next(String key, String value, int points) async {
    controller.addAnswer(key, value, points);

    if (step == 3) {
      await controller.submit();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {
        step++;
        selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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

              if (step == 1) ...[
                LogOptionTile(
                  text: 'Public Transport',
                  selected: selected == 'Public',
                  onTap: () {
                    setState(() => selected = 'Public');
                    next('transport', 'Public', 5);
                  },
                ),
                LogOptionTile(
                  text: 'Bike',
                  selected: selected == 'Bike',
                  onTap: () {
                    setState(() => selected = 'Bike');
                    next('transport', 'Bike', 3);
                  },
                ),
              ],

              if (step == 2) ...[
                LogOptionTile(
                  text: 'Veg',
                  selected: selected == 'Veg',
                  onTap: () {
                    setState(() => selected = 'Veg');
                    next('food', 'Veg', 4);
                  },
                ),
                LogOptionTile(
                  text: 'Mixed Diet',
                  selected: selected == 'Mixed',
                  onTap: () {
                    setState(() => selected = 'Mixed');
                    next('food', 'Mixed', 2);
                  },
                ),
              ],

              if (step == 3) ...[
                LogOptionTile(
                  text: 'Fan',
                  selected: selected == 'Fan',
                  onTap: () {
                    setState(() => selected = 'Fan');
                    next('energy', 'Fan', 3);
                  },
                ),
                LogOptionTile(
                  text: 'AC',
                  selected: selected == 'AC',
                  onTap: () {
                    setState(() => selected = 'AC');
                    next('energy', 'AC', 0);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_option_tile.dart';
import '../widgets/onboarding_continue_button.dart';

class OnboardingCollegeScreen extends StatefulWidget {
  const OnboardingCollegeScreen({super.key});

  @override
  State<OnboardingCollegeScreen> createState() =>
      _OnboardingCollegeScreenState();
}

class _OnboardingCollegeScreenState extends State<OnboardingCollegeScreen> {
  // ✅ Controller is CREATED ONLY HERE (first onboarding screen)
  final OnboardingController controller = OnboardingController();

  String? selected;

  final colleges = [
    'IIT Mumbai',
    'BITS Pilani',
    'MGMCET',
    'AP Shah',
    'KJ Somaiya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "What's your college? 🎓",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "We'll connect you with your campus community",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: colleges.map((college) {
                    return OnboardingOptionTile(
                      text: college,
                      selected: selected == college,
                      onTap: () => setState(() => selected = college),
                    );
                  }).toList(),
                ),
              ),

              OnboardingContinueButton(
                enabled: selected != null,
                onPressed: () {
                  controller.setCollege(selected!);

                  // ✅ Pass SAME controller forward
                  Navigator.pushNamed(
                    context,
                    '/onboarding-accommodation',
                    arguments: controller,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_option_tile.dart';
import '../widgets/onboarding_continue_button.dart';

class OnboardingTravelScreen extends StatefulWidget {
  const OnboardingTravelScreen({super.key});

  @override
  State<OnboardingTravelScreen> createState() =>
      _OnboardingTravelScreenState();
}

class _OnboardingTravelScreenState extends State<OnboardingTravelScreen> {
  String? selected;

  final options = [
    'Public Transport',
    'Local Train',
    'Motorbike',
    'Car',
  ];

  @override
  Widget build(BuildContext context) {
    final controller =
        ModalRoute.of(context)!.settings.arguments as OnboardingController;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How do you commute? 🚶‍♂️',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: options.map((o) {
                    return OnboardingOptionTile(
                      text: o,
                      selected: selected == o,
                      onTap: () => setState(() => selected = o),
                    );
                  }).toList(),
                ),
              ),

              OnboardingContinueButton(
                enabled: selected != null,
                onPressed: () {
                  controller.setTransport(selected!);
                  Navigator.pushNamed(
                    context,
                    '/onboarding-notifications',
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


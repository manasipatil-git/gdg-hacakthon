import 'package:flutter/material.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_option_tile.dart';
import '../widgets/onboarding_continue_button.dart';

class OnboardingAccommodationScreen extends StatefulWidget {
  const OnboardingAccommodationScreen({super.key});

  @override
  State<OnboardingAccommodationScreen> createState() =>
      _OnboardingAccommodationScreenState();
}

class _OnboardingAccommodationScreenState
    extends State<OnboardingAccommodationScreen> {
  String? selected;

  final options = ['Hostel', 'Home', 'PG / Apartment'];

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
                'Where do you stay? 🏠',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Help us personalize your eco journey',
                style: TextStyle(color: Colors.black54),
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
                  controller.setAccommodation(selected!);
                  Navigator.pushNamed(
                    context,
                    '/onboarding-food',
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

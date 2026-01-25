import 'package:flutter/material.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_option_tile.dart';
import '../widgets/onboarding_continue_button.dart';

class OnboardingFoodScreen extends StatefulWidget {
  const OnboardingFoodScreen({super.key});

  @override
  State<OnboardingFoodScreen> createState() => _OnboardingFoodScreenState();
}

class _OnboardingFoodScreenState extends State<OnboardingFoodScreen> {
  String? selected;

  final options = ['Veg', 'Mixed Diet', 'Non-Veg'];

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
                'Food preference 🍽️',
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
                  controller.setFood(selected!);
                  Navigator.pushNamed(
                    context,
                    '/onboarding-transport',
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

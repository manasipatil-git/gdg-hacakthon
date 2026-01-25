import 'package:flutter/material.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_continue_button.dart';

class OnboardingNotificationScreen extends StatefulWidget {
  const OnboardingNotificationScreen({super.key});

  @override
  State<OnboardingNotificationScreen> createState() =>
      _OnboardingNotificationScreenState();
}

class _OnboardingNotificationScreenState
    extends State<OnboardingNotificationScreen> {
  bool enabled = true;

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
                'Enable notifications 🔔',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'We’ll remind you about eco-friendly actions',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              SwitchListTile(
                value: enabled,
                onChanged: (v) => setState(() => enabled = v),
                title: const Text('Allow notifications'),
              ),

              const Spacer(),

              OnboardingContinueButton(
                enabled: true,
                onPressed: () async {
                  controller.setNotifications(enabled);
                  await controller.finish();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (_) => false,
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

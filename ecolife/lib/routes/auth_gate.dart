import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firestore_service.dart';
import '../features/onboarding/screens/onboarding_college_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(); // splash later
        }

        final user = snapshot.data!;
        final firestore = FirestoreService();

        return FutureBuilder<bool>(
          future: firestore.isOnboardingCompleted(user.uid),
          builder: (context, onboardingSnap) {
            if (!onboardingSnap.hasData) {
              return const SizedBox();
            }

            return onboardingSnap.data!
                ? const DashboardScreen()
                : const OnboardingCollegeScreen();
          },
        );
      },
    );
  }
}

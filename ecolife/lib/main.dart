import 'package:flutter/material.dart';

// Auth
// ignore: unused_import
import 'auth/welcome_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';

// Core screens
import 'onboarding/onboarding_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'leaderboard/leaderboard_screen.dart';

// Optional (if already created)
import 'screens/log_today_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoLife',
      initialRoute: '/welcome',

      routes: {
        // AUTH
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),

        // APP FLOW
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/log': (context) => const LogTodayScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/log_today_screen.dart';
import 'screens/leaderboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carbon App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/log': (context) => const LogTodayScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}

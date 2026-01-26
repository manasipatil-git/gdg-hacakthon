import 'package:flutter/material.dart';

// AUTH
import '../features/auth/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';

// DASHBOARD
import '../features/dashboard/screens/dashboard_screen.dart';

// LOG
import '../features/log/screens/log_quiz_screen.dart';

// LEADERBOARD
import '../features/leaderboard/screens/leaderboard_screen.dart';

// REWARDS
import '../features/rewards/screens/rewards_screen.dart';

// SETTINGS
import '../features/settings/screens/settings_screen.dart';

// ONBOARDING
import '../features/onboarding/screens/onboarding_college_screen.dart';
import '../features/onboarding/screens/onboarding_travel_screen.dart';
import '../features/onboarding/screens/onboarding_food_screen.dart';
import '../features/onboarding/screens/onboarding_notifications_screen.dart';
import '../features/onboarding/screens/onboarding_accommodation_screen.dart';

//challenges
import '../features/challenges/screens/challenges_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/':
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
        );

      // -------- ONBOARDING --------
case '/onboarding':
  return MaterialPageRoute(
    builder: (_) => const OnboardingCollegeScreen(),
    settings: settings,
  );

case '/onboarding-accommodation':
  return MaterialPageRoute(
    builder: (_) => const OnboardingAccommodationScreen(),
    settings: settings,
  );

case '/onboarding-transport':
  return MaterialPageRoute(
    builder: (_) => const OnboardingTravelScreen(),
    settings: settings,
  );

case '/onboarding-food':
  return MaterialPageRoute(
    builder: (_) => const OnboardingFoodScreen(),
    settings: settings,
  );

case '/onboarding-notifications':
  return MaterialPageRoute(
    builder: (_) => const OnboardingNotificationScreen(),
    settings: settings,
  );


      // -------- DASHBOARD --------
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      // -------- OTHER --------
      case '/log':
        return MaterialPageRoute(
          builder: (_) => const LogScreen(),
        );

      case '/leaderboard':
        return MaterialPageRoute(
          builder: (_) => const LeaderboardScreen(),
        );

      case '/rewards':
        return MaterialPageRoute(
          builder: (_) => const RewardsScreen(),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

        case '/challenges':
         return MaterialPageRoute(
           builder: (_) => const ChallengesScreen(),
         );


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
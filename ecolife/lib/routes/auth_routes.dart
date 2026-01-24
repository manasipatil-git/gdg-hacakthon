import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/welcome_screen.dart';

final authRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignupScreen(),
};

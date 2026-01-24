import 'package:flutter/material.dart';
import '../shared/constants/colors.dart';
import 'auth_service.dart';

/// ---------- SHARED INPUT ----------
Widget authInput(
  String hint, {
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      obscureText: isPassword,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryGreen,
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.white.withOpacity(0.9),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

/// ---------- SIGNUP SCREEN ----------
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/sloth_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Image.asset(
                    'assets/images/logo.png',
                    height: 64,
                  ),

                  const SizedBox(height: 40),

                  authInput('Your Name'),
                  authInput('Email'),
                  authInput('Password', isPassword: true),

                  const SizedBox(height: 16),

                  _googleButton(),

                  const SizedBox(height: 16),

                  _primaryButton(
                    text: "I'M READY",
                    onTap: () {},
                  ),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return ElevatedButton.icon(
      onPressed: _auth.loginWithGoogle,
      icon: const Icon(Icons.g_mobiledata, size: 28),
      label: const Text('Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.googleRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: AppColors.textDark,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Text(text),
    );
  }
}

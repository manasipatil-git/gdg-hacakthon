import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 80),
                  const SizedBox(height: 40),
                  _button(
                    text: 'SIGN IN',
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 16),
                  _button(
                    text: 'SIGN UP',
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({required String text, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGreen,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text),
    );
  }
}

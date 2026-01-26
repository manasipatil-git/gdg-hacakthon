import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_text_field.dart';
import '../auth_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/user_provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              const Text(
                'EcoLife',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              Image.asset(
                'assets/images/sloth_smile.png',
                height: 180,
              ),

              const SizedBox(height: 16),

              const Text(
                'Create your EcoLife',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              AuthTextField(
                hint: 'Your Name',
                controller: _name,
              ),

              AuthTextField(
                hint: 'Email',
                controller: _email,
              ),

              AuthTextField(
                hint: 'Password',
                controller: _password,
                isPassword: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth.signup(
                        _name.text,
                        _email.text,
                        _password.text,
                      );

                      // 🔑 IMPORTANT: reset session state for new user
                      context.read<UserProvider>().clear();

                      Navigator.pushReplacementNamed(
                        context,
                        '/onboarding',
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "I'M READY",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

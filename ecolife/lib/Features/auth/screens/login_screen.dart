import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../auth_controller.dart';
import '../../../core/constants/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔰 LOGO SECTION (TOP)
              const SizedBox(height: 24),
              const Text(
                'EcoLife',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // 🦥 BIGGER SLOTH
              Image.asset(
                'assets/images/sloth_hide_eyes.png',
                height: 180, // 👈 increased from ~140
              ),

              const SizedBox(height: 16),

              const Text(
                'Log in to EcoLife',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              // ✍️ INPUTS
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

              // 🔘 LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final next =
                          await _auth.login(_email.text, _password.text);
                      Navigator.pushReplacementNamed(context, next);
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
                    'LOGIN',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 🔗 FORGOT PASSWORD
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black54),
                ),
              ),

              // ⬇️ PUSH EVERYTHING UP, LEAVE BREATHING SPACE
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

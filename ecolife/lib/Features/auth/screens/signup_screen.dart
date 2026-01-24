import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../auth_controller.dart';
import '../../../core/constants/colors.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/sloth_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset('assets/images/logo.png', height: 64),
                  const SizedBox(height: 40),
                  AuthTextField(hint: 'Your Name', controller: _name),
                  AuthTextField(hint: 'Email', controller: _email),
                  AuthTextField(
                    hint: 'Password',
                    controller: _password,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _auth.signup(
                        _name.text,
                        _email.text,
                        _password.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("I'M READY"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

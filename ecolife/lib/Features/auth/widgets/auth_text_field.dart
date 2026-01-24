import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
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
}

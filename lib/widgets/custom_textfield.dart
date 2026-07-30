import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: colors.textSecondary),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: colors.gold),
        ),
      ),
    );
  }
}
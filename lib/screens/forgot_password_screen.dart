import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  String message = '';
  bool isError = false;

  void _resetPassword() async {
    setState(() {
      isLoading = true;
      message = '';
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        message = 'Password reset link sent to your email';
        isError = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? 'Something went wrong';
        isError = true;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your email to receive a password reset link.', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 24),
            CustomTextField(hintText: 'Email', controller: emailController),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(message, style: TextStyle(color: isError ? colors.error : colors.success, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            isLoading
                ? Center(child: CircularProgressIndicator(color: colors.gold))
                : CustomButton(text: 'Send Reset Link', onPressed: _resetPassword),
          ],
        ),
      ),
    );
  }
}
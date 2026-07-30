import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../app_routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? timer;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => _checkVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _checkVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      timer?.cancel();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    }
  }

  void _resendEmail() async {
    setState(() => isSending = true);
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    setState(() => isSending = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email sent again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_unread_outlined, size: 70, color: colors.gold),
            const SizedBox(height: 24),
            Text('Verify Your Email',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.textPrimary)),
            const SizedBox(height: 12),
            Text(
              'We sent a verification link to ${FirebaseAuth.instance.currentUser?.email ?? "your email"}. Please check your inbox.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 32),
            isSending
                ? CircularProgressIndicator(color: colors.gold)
                : CustomButton(text: 'Resend Email', onPressed: _resendEmail),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                }
              },
              child: Text('Back to Login', style: TextStyle(color: colors.purple)),
            ),
          ],
        ),
      ),
    );
  }
}
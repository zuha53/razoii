import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  void _signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill in all fields');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => errorMessage = 'Please enter a valid email');
      return;
    }
    if (password.length < 6) {
      setState(() => errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? 'Signup failed');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.gold)),
              const SizedBox(height: 8),
              Text('Sign up to start shopping', style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 32),
              CustomTextField(hintText: 'Full Name', controller: nameController),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Password', controller: passwordController, isPassword: true),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(errorMessage, style: TextStyle(color: colors.error, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: colors.gold))
                  : CustomButton(text: 'Sign Up', onPressed: _signup),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Already have an account? Login', style: TextStyle(color: colors.purple)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
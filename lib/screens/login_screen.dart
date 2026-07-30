import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill in all fields');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => errorMessage = 'Please enter a valid email');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? 'Login failed');
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
              Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.gold)),
              const SizedBox(height: 8),
              Text('Login to continue shopping', style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 32),
              CustomTextField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Password', controller: passwordController, isPassword: true),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(errorMessage, style: TextStyle(color: colors.error, fontSize: 13)),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: Text('Forgot Password?', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: colors.gold))
                  : CustomButton(text: 'Login', onPressed: _login),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                  child: Text("Don't have an account? Sign Up", style: TextStyle(color: colors.purple)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
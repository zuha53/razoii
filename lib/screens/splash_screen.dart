import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward();
    _navigateToNext();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    String nextRoute;
    if (user == null) {
      nextRoute = AppRoutes.login;
    } else if (!user.emailVerified) {
      nextRoute = AppRoutes.emailVerification;
    } else {
      nextRoute = AppRoutes.main;
    }
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Razoii', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: colors.gold)),
                const SizedBox(height: 8),
                Text('Luxury Shopping Experience', style: TextStyle(fontSize: 14, color: colors.purple)),
                const SizedBox(height: 40),
                CircularProgressIndicator(color: colors.gold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
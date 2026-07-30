import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'services/providers/cart_provider.dart';
import 'services/providers/wishlist_provider.dart';
import 'services/providers/order_provider.dart';
import 'services/providers/theme_provider.dart';
import 'app_routes.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/main_wrapper_screen.dart';
import 'screens/luxury_animated_login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RazoiiApp());
}

class RazoiiApp extends StatelessWidget {
  const RazoiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Razoii',
            theme: themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.onboarding: (context) => const OnboardingScreen(),
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.signup: (context) => const SignupScreen(),
              AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
              AppRoutes.emailVerification: (context) => const EmailVerificationScreen(),
              AppRoutes.main: (context) => const MainWrapperScreen(),
            },
          ),
        ),
      ),
    );
  }
}
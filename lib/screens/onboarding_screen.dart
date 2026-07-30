import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {'title': 'Welcome to Razoii', 'subtitle': 'Discover a curated collection of luxury products, all in one place.'},
    {'title': 'Shop with Confidence', 'subtitle': 'Browse, save favorites, and checkout securely — anytime, anywhere.'},
    {'title': 'Fast & Reliable', 'subtitle': 'Track your orders and enjoy a smooth shopping experience.'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.diamond_outlined, size: 80, color: colors.gold),
                        const SizedBox(height: 32),
                        Text(
                          pages[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pages[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? colors.gold : colors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: () {
                  if (currentPage == pages.length - 1) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  } else {
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
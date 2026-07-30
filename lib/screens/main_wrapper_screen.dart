import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../services/providers/cart_provider.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../widgets/no_internet_banner.dart';
class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: NoInternetBanner(child: screens[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: colors.surface,
        selectedItemColor: colors.gold,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Badge(
                  label: Text('${cartProvider.itemCount}'),
                  isLabelVisible: cartProvider.itemCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
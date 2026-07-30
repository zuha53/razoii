import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../app_routes.dart';
import 'order_history_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colors.surface,
                    child: Icon(Icons.person, size: 40, color: colors.gold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName?.isNotEmpty == true ? user!.displayName! : 'Razoii User',
                    style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: TextStyle(color: colors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _ProfileTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
            ),
            _ProfileTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
            ),
            _ProfileTile(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen())),
            ),
            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
            ),
            const SizedBox(height: 20),
            _ProfileTile(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card(
      color: colors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? colors.gold),
        title: Text(title, style: TextStyle(color: colors.textPrimary)),
        trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../services/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Appearance', style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: colors.gold,
              ),
              title: Text('Dark Mode', style: TextStyle(color: colors.textPrimary)),
              subtitle: Text(
                themeProvider.isDarkMode ? 'Currently On' : 'Currently Off',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              value: themeProvider.isDarkMode,
              activeColor: colors.gold,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),
          Text('Information', style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: colors.gold),
                  title: Text('About Razoii', style: TextStyle(color: colors.textPrimary)),
                  trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
                  onTap: () => _showInfoSheet(
                    context,
                    'About Razoii',
                    'Razoii is a luxury shopping app offering a curated collection of premium products. '
                        'Built with Flutter and Firebase, this app is a portfolio project showcasing modern '
                        'mobile app development practices.\n\nVersion 1.0.0',
                  ),
                ),
                Divider(height: 1, color: colors.surface),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: colors.gold),
                  title: Text('Privacy Policy', style: TextStyle(color: colors.textPrimary)),
                  trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
                  onTap: () => _showInfoSheet(
                    context,
                    'Privacy Policy',
                    'This is a demo application built for portfolio purposes. No real personal data is sold '
                        'or shared with third parties. Data entered (such as email and address) is used only '
                        'to demonstrate app functionality and is stored securely via Firebase.',
                  ),
                ),
                Divider(height: 1, color: colors.surface),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: colors.gold),
                  title: Text('Terms & Conditions', style: TextStyle(color: colors.textPrimary)),
                  trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
                  onTap: () => _showInfoSheet(
                    context,
                    'Terms & Conditions',
                    'By using this demo app, you acknowledge it is a portfolio project and not a live '
                        'commercial service. All products, prices, and orders within the app are for '
                        'demonstration purposes only.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String content) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: colors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(content, style: TextStyle(color: colors.textSecondary, height: 1.5)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
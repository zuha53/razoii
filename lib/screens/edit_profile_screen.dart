import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    nameController = TextEditingController(text: user?.displayName ?? '');
  }

  void _saveProfile() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.pop(context);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 8),
            CustomTextField(hintText: 'Full Name', controller: nameController),
            const SizedBox(height: 20),
            Text('Email', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: 8),
            Text(user?.email ?? '', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
            const SizedBox(height: 30),
            isLoading
                ? Center(child: CircularProgressIndicator(color: colors.gold))
                : CustomButton(text: 'Save Changes', onPressed: _saveProfile),
          ],
        ),
      ),
    );
  }
}
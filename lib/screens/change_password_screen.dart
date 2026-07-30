import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isLoading = false;
  String message = '';
  bool isError = false;

  void _changePassword() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        final credential =
            EmailAuthProvider.credential(email: email, password: currentPasswordController.text.trim());
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPasswordController.text.trim());
        setState(() {
          message = 'Password changed successfully';
          isError = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? 'Something went wrong';
        isError = true;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(hintText: 'Current Password', controller: currentPasswordController, isPassword: true),
            const SizedBox(height: 16),
            CustomTextField(hintText: 'New Password', controller: newPasswordController, isPassword: true),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(message, style: TextStyle(color: isError ? colors.error : colors.success, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            isLoading
                ? Center(child: CircularProgressIndicator(color: colors.gold))
                : CustomButton(text: 'Update Password', onPressed: _changePassword),
          ],
        ),
      ),
    );
  }
}
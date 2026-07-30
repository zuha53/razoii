import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../models/address_model.dart';
import '../app_routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  final AddressModel address;
  final double total;

  const OrderSuccessScreen({super.key, required this.address, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: colors.success, size: 90),
            const SizedBox(height: 24),
            Text('Order Placed!', style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Your order of \$${total.toStringAsFixed(2)} will be delivered to ${address.street}, ${address.city}.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Continue Shopping',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
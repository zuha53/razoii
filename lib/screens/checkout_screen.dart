import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/providers/cart_provider.dart';
import '../services/order_service.dart';
import '../models/address_model.dart';
import '../models/order_model.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final postalController = TextEditingController();
  bool isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address',
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            CustomTextField(hintText: 'Full Name', controller: nameController),
            const SizedBox(height: 12),
            CustomTextField(hintText: 'Phone Number', controller: phoneController),
            const SizedBox(height: 12),
            CustomTextField(hintText: 'Street Address', controller: streetController),
            const SizedBox(height: 12),
            CustomTextField(hintText: 'City', controller: cityController),
            const SizedBox(height: 12),
            CustomTextField(hintText: 'Postal Code', controller: postalController),
            const SizedBox(height: 24),
            Text('Order Summary',
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ...cartProvider.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.product.name} x${item.quantity}',
                                style: TextStyle(color: colors.textSecondary)),
                          ),
                          Text('\$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: colors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: colors.surface),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                      Text('\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: colors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            isPlacingOrder
                ? Center(child: CircularProgressIndicator(color: colors.gold))
                : CustomButton(
                    text: 'Place Order',
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty ||
                          phoneController.text.trim().isEmpty ||
                          streetController.text.trim().isEmpty ||
                          cityController.text.trim().isEmpty ||
                          postalController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Please fill all address fields')));
                        return;
                      }

                      setState(() => isPlacingOrder = true);

                      final address = AddressModel(
                        fullName: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        street: streetController.text.trim(),
                        city: cityController.text.trim(),
                        postalCode: postalController.text.trim(),
                      );

                      final orderTotal = cartProvider.totalPrice;

                      final newOrder = OrderModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        items: List.from(cartProvider.items),
                        address: address,
                        total: orderTotal,
                        date: DateTime.now(),
                      );

                      await OrderService().placeOrder(newOrder);
                      cartProvider.clearCart();

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSuccessScreen(address: address, total: orderTotal),
                          ),
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
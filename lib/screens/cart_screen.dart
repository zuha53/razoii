import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/empty_widget.dart';
import '../services/providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('My Cart')),
      body: items.isEmpty
          ? const EmptyWidget(message: 'Your cart is empty', icon: Icons.shopping_cart_outlined)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.image, color: colors.textSecondary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('\$${item.product.price.toStringAsFixed(2)}',
                                      style: TextStyle(color: colors.gold)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context.read<CartProvider>().decreaseQuantity(item.product.id),
                                      child: Icon(Icons.remove_circle_outline, color: colors.textSecondary, size: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('${item.quantity}', style: TextStyle(color: colors.textPrimary)),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<CartProvider>().increaseQuantity(item.product.id),
                                      child: Icon(Icons.add_circle_outline, color: colors.gold, size: 20),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () => context.read<CartProvider>().removeFromCart(item.product.id),
                                  child: Text('Remove', style: TextStyle(color: colors.error, fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
                          Text('\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(color: colors.gold, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Proceed to Checkout',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
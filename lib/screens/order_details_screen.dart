import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text('Order #${order.id.substring(order.id.length - 6)}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(order.statusText, style: TextStyle(color: colors.gold, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Text('Items', style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
            Divider(color: colors.surface, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                Text('\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(color: colors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Shipping Address',
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${order.address.fullName}\n${order.address.street}, ${order.address.city}\n${order.address.postalCode}\n${order.address.phone}',
              style: TextStyle(color: colors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
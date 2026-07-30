import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final orderService = OrderService();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingWidget();
          if (snapshot.hasError) return const AppErrorWidget(message: 'Failed to load orders');
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) return const EmptyWidget(message: 'No orders yet', icon: Icons.receipt_long_outlined);

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #${order.id.substring(order.id.length - 6)}',
                              style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${order.items.length} item(s) • \$${order.total.toStringAsFixed(2)}',
                              style: TextStyle(color: colors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.gold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(order.statusText,
                            style: TextStyle(color: colors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
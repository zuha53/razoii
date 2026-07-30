import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_widget.dart';
import '../services/providers/wishlist_provider.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wishlistProvider = context.watch<WishlistProvider>();
    final items = wishlistProvider.items;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Wishlist')),
      body: items.isEmpty
          ? const EmptyWidget(message: 'Your wishlist is empty', icon: Icons.favorite_border)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                          );
                        },
                        child: ProductCard(
                          name: product.name,
                          price: '\$${product.price.toStringAsFixed(0)}',
                          imageUrl: product.imageUrl,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => wishlistProvider.removeFromWishlist(product.id),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: colors.background, shape: BoxShape.circle),
                            child: Icon(Icons.close, color: colors.error, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
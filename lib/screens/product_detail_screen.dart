import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../models/product_model.dart';
import '../widgets/custom_button.dart';
import '../services/providers/wishlist_provider.dart';
import '../services/providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isSaved = wishlistProvider.isInWishlist(product.id);
              return IconButton(
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? colors.error : colors.textPrimary),
                onPressed: () => wishlistProvider.toggleWishlist(product),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: _ImageSlider(
                imageUrls: product.imageUrls.isNotEmpty ? product.imageUrls : [product.imageUrl],
              ),
            ),
            const SizedBox(height: 20),
            Text(product.name,
                style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: colors.gold, size: 18),
                const SizedBox(width: 4),
                Text(product.rating.toString(), style: TextStyle(color: colors.textSecondary)),
                const SizedBox(width: 16),
                Text(
                  product.stock > 0 ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(color: product.stock > 0 ? colors.success : colors.error),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(color: colors.gold, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Description',
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description, style: TextStyle(color: colors.textSecondary, height: 1.5)),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Add to Cart',
              onPressed: () {
                context.read<CartProvider>().addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageSlider({required this.imageUrls});

  @override
  State<_ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<_ImageSlider> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              final url = widget.imageUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  color: colors.surface,
                  child: url.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator(color: colors.gold)),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image, size: 60, color: colors.textSecondary),
                        )
                      : Icon(Icons.image, size: 60, color: colors.textSecondary),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentPage == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: currentPage == index ? colors.gold : colors.cardBackground,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
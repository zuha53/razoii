import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_card.dart';
import '../screens/product_detail_screen.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ProductGrid({
    super.key,
    required this.products,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
            );
          },
          child: ProductCard(
            name: product.name,
            price: '\$${product.price.toStringAsFixed(0)}',
            heroTag: 'product-${product.id}',
            imageUrl: product.imageUrl,
          ),
        );
      },
    );
  }
}
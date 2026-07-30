import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String? heroTag;
  final String? imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.heroTag,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: heroTag ?? UniqueKey(),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMedium)),
                child: Container(
                  width: double.infinity,
                  color: colors.surface,
                  child: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator(color: colors.gold, strokeWidth: 2)),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image, color: colors.textSecondary, size: 40),
                        )
                      : Icon(Icons.image, color: colors.textSecondary, size: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(price, style: TextStyle(color: colors.gold, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
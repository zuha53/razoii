import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/product_grid.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductService productService = ProductService();
  final CategoryService categoryService = CategoryService();
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Razoii')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(hintText: 'Search products...', controller: searchController),
              const SizedBox(height: 16),
              _BannerSlider(),
              const SizedBox(height: 20),
              Text('Categories',
                  style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              StreamBuilder<List<CategoryModel>>(
                stream: categoryService.getCategories(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  if (categories.isEmpty) return const SizedBox(height: 40);
                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final categoryName = categories[index].name;
                        final isSelected = categoryName == selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = categoryName),
                          child: Chip(
                            label: Text(categoryName),
                            backgroundColor: isSelected ? colors.gold : colors.surface,
                            labelStyle: TextStyle(color: isSelected ? colors.black : colors.textPrimary),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                selectedCategory == 'All' ? 'Featured Products' : selectedCategory,
                style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<ProductModel>>(
                stream: productService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 200, child: LoadingWidget());
                  }
                  if (snapshot.hasError) {
                    return const SizedBox(height: 200, child: AppErrorWidget(message: 'Failed to load products'));
                  }
                  final allProducts = snapshot.data ?? [];
                  final products = selectedCategory == 'All'
                      ? allProducts
                      : allProducts.where((p) => p.category == selectedCategory).toList();

                  if (products.isEmpty) {
                    return Center(
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('No products available', style: TextStyle(color: colors.textSecondary)),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 400,
                        child: ProductGrid(
                          products: products,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (selectedCategory == 'All') ...[
                        Text('Popular Products',
                            style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = products.reversed.toList()[index];
                              return SizedBox(
                                width: 140,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(product: product),
                                      ),
                                    );
                                  },
                                  child: ProductCard(
                                    name: product.name,
                                    price: '\$${product.price.toStringAsFixed(0)}',
                                    heroTag: 'popular-${product.id}',
                                    imageUrl: product.imageUrl,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerSlider extends StatefulWidget {
  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final banners = [
      {'text': 'New Collection\nUp to 30% Off', 'colors': [colors.purple, colors.gold]},
      {'text': 'Free Shipping\nOn Orders Over \$100', 'colors': [colors.gold, colors.purple]},
      {'text': 'Limited Edition\nShop Now', 'colors': [colors.cardBackground, colors.gold]},
    ];

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: List<Color>.from(banner['colors'] as List),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      banner['text'] as String,
                      style: TextStyle(color: colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentPage == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: currentPage == index ? colors.gold : colors.surface,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
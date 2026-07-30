import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/product_grid.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductService productService = ProductService();
  String query = '';
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
      if (searchController.text.trim().isEmpty) query = '';
    });
  }

  void _runSearch() {
    final searchText = searchController.text.trim();
    if (searchText.isEmpty) return;
    setState(() {
      query = searchText;
      recentSearches.remove(searchText);
      recentSearches.insert(0, searchText);
      if (recentSearches.length > 5) recentSearches = recentSearches.sublist(0, 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFieldEmpty = searchController.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(hintText: 'Search for products...', controller: searchController),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _runSearch,
              child: Text('Search', style: TextStyle(color: colors.gold)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isFieldEmpty
                  ? recentSearches.isEmpty
                      ? const EmptyWidget(message: 'Search for your favorite products', icon: Icons.search)
                      : ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Recent Searches',
                                  style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            ...recentSearches.map((term) => ListTile(
                                  leading: Icon(Icons.history, color: colors.textSecondary),
                                  title: Text(term, style: TextStyle(color: colors.textPrimary)),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close, color: colors.textSecondary, size: 18),
                                    onPressed: () => setState(() => recentSearches.remove(term)),
                                  ),
                                  onTap: () {
                                    searchController.text = term;
                                    _runSearch();
                                  },
                                )),
                          ],
                        )
                  : query.isEmpty
                      ? const SizedBox.shrink()
                      : StreamBuilder<List<ProductModel>>(
                          stream: productService.getProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const LoadingWidget();
                            }
                            if (snapshot.hasError) {
                              return const AppErrorWidget(message: 'Failed to load products');
                            }
                            final allProducts = snapshot.data ?? [];
                            final filteredProducts = allProducts
                                .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
                                .toList();

                            if (filteredProducts.isEmpty) {
                              return const EmptyWidget(message: 'No results found', icon: Icons.search_off);
                            }

                            return ProductGrid(products: filteredProducts);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
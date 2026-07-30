import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService();
  List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  WishlistProvider() {
    _service.getWishlist().listen((products) {
      _items = products;
      notifyListeners();
    });
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      _service.removeFromWishlist(product.id);
    } else {
      _service.addToWishlist(product);
    }
  }

  void removeFromWishlist(String productId) {
    _service.removeFromWishlist(productId);
  }
}
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';
import '../cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();
  List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartProvider() {
    _service.getCart().listen((cartItems) {
      _items = cartItems;
      notifyListeners();
    });
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void addToCart(ProductModel product) {
    _service.addToCart(product);
  }

  void removeFromCart(String productId) {
    _service.removeFromCart(productId);
  }

  void increaseQuantity(String productId) {
    _service.increaseQuantity(productId);
  }

  void decreaseQuantity(String productId) {
    _service.decreaseQuantity(productId);
  }

  void clearCart() {
    _service.clearCart();
  }
}
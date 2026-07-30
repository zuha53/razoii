import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartService {
  CollectionReference? get _cartRef {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');
  }

  Future<void> addToCart(ProductModel product) async {
    final ref = _cartRef;
    if (ref == null) return;

    final doc = await ref.doc(product.id).get();
    if (doc.exists) {
      final currentQty = (doc.data() as Map<String, dynamic>)['quantity'] ?? 1;
      await ref.doc(product.id).update({'quantity': currentQty + 1});
    } else {
      await ref.doc(product.id).set({
        'productId': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'rating': product.rating,
        'stock': product.stock,
        'quantity': 1,
      });
    }
  }

  Future<void> increaseQuantity(String productId) async {
    final ref = _cartRef;
    if (ref == null) return;
    final doc = await ref.doc(productId).get();
    if (doc.exists) {
      final currentQty = (doc.data() as Map<String, dynamic>)['quantity'] ?? 1;
      await ref.doc(productId).update({'quantity': currentQty + 1});
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    final ref = _cartRef;
    if (ref == null) return;
    final doc = await ref.doc(productId).get();
    if (doc.exists) {
      final currentQty = (doc.data() as Map<String, dynamic>)['quantity'] ?? 1;
      if (currentQty > 1) {
        await ref.doc(productId).update({'quantity': currentQty - 1});
      } else {
        await ref.doc(productId).delete();
      }
    }
  }

  Future<void> removeFromCart(String productId) async {
    final ref = _cartRef;
    if (ref == null) return;
    await ref.doc(productId).delete();
  }

  Future<void> clearCart() async {
    final ref = _cartRef;
    if (ref == null) return;
    final snapshot = await ref.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<CartItemModel>> getCart() {
    final ref = _cartRef;
    if (ref == null) return const Stream.empty();

    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final product = ProductModel.fromFirestore(doc.id, data);
        return CartItemModel(
          product: product,
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
    });
  }
}
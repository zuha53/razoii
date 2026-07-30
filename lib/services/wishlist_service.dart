import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class WishlistService {
  CollectionReference? get _wishlistRef {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist');
  }

  Future<void> addToWishlist(ProductModel product) async {
    final ref = _wishlistRef;
    if (ref == null) return;
    await ref.doc(product.id).set({
      'productId': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'rating': product.rating,
      'stock': product.stock,
      'imageUrl': product.imageUrl,
      'imageUrls': product.imageUrls,
    });
  }

  Future<void> removeFromWishlist(String productId) async {
    final ref = _wishlistRef;
    if (ref == null) return;
    await ref.doc(productId).delete();
  }

  Stream<List<ProductModel>> getWishlist() {
    final ref = _wishlistRef;
    if (ref == null) return const Stream.empty();

    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromFirestore(doc.id, data);
      }).toList();
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _ordersRef =
      FirebaseFirestore.instance.collection('orders');

  Future<void> placeOrder(OrderModel order) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _ordersRef.doc(order.id).set(order.toFirestore(userId));
  }

  Stream<List<OrderModel>> getUserOrders() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _ordersRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) =>
              OrderModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    });
  }
}
import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders.reversed.toList();

  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }
}
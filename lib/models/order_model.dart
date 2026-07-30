import 'cart_item_model.dart';
import 'address_model.dart';
import 'product_model.dart';
enum OrderStatus { pending, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final AddressModel address;
  final double total;
  final DateTime date;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.address,
    required this.total,
    required this.date,
    this.status = OrderStatus.pending,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> toFirestore(String userId) {
    return {
      'userId': userId,
      'items': items
          .map((item) => {
                'productId': item.product.id,
                'name': item.product.name,
                'price': item.product.price,
                'quantity': item.quantity,
              })
          .toList(),
      'address': {
        'fullName': address.fullName,
        'phone': address.phone,
        'street': address.street,
        'city': address.city,
        'postalCode': address.postalCode,
      },
      'total': total,
      'date': date.toIso8601String(),
      'status': status.name,
    };
  }

  factory OrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    final itemsData = data['items'] as List<dynamic>? ?? [];
    final addressData = data['address'] as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: id,
      items: itemsData.map((itemData) {
        return CartItemModel(
          product: ProductModel(
            id: itemData['productId'] ?? '',
            name: itemData['name'] ?? '',
            description: '',
            price: (itemData['price'] ?? 0).toDouble(),
            category: '',
          ),
          quantity: itemData['quantity'] ?? 1,
        );
      }).toList(),
      address: AddressModel(
        fullName: addressData['fullName'] ?? '',
        phone: addressData['phone'] ?? '',
        street: addressData['street'] ?? '',
        city: addressData['city'] ?? '',
        postalCode: addressData['postalCode'] ?? '',
      ),
      total: (data['total'] ?? 0).toDouble(),
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
    );
  }
}


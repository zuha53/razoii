class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final double rating;
  final int stock;
  final String imageUrl;
  final List<String> imageUrls;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.rating = 0.0,
    this.stock = 0,
    this.imageUrl = '',
    this.imageUrls = const [],
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      stock: (data['stock'] ?? 0).toInt(),
      imageUrl: data['imageUrl'] ?? '',
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'])
          : [],
    );
  }
}
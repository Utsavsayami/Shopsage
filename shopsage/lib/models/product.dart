class Product {
  String id;
  String name;
  String sku;
  double price;
  int stock;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt,
    );
  }
}

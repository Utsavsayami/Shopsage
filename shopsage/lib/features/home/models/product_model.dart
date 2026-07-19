class ProductModel {
  final String id;
  final String name;
  final String? brand;
  final String? category;
  final double price;
  final int stock;
  final List<String> imageUrls;
  final String? description;

  ProductModel({
    required this.id,
    required this.name,
    this.brand,
    this.category,
    required this.price,
    required this.stock,
    required this.imageUrls,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown product',
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      price: (json['price'] is num
              ? json['price'] as num
              : double.tryParse(json['price']?.toString() ?? '0') ?? 0)
          .toDouble(),
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((item) => item?.toString() ?? '')
              .where((item) => item.isNotEmpty)
              .toList() ??
          const [],
      description: json['description']?.toString(),
    );
  }

  String? get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;
}

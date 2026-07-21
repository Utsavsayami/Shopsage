import 'package:shopsage_auth_app/models/product.dart';

class ProductService {
  ProductService._privateConstructor();
  static final ProductService instance = ProductService._privateConstructor();

  // Returns some sample products to seed the UI.
  List<Product> seedProducts() {
    return [
      Product(
          id: 'p1',
          name: 'Arc Wireless Headset',
          sku: 'SSH-102',
          price: 59.99,
          stock: 14),
      Product(
          id: 'p2',
          name: 'Compact Power Hub',
          sku: 'SSH-117',
          price: 29.99,
          stock: 8),
      Product(
          id: 'p3',
          name: 'Modular Stand',
          sku: 'SSH-124',
          price: 39.99,
          stock: 24),
    ];
  }
}

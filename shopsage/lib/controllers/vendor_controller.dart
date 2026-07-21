import 'package:get/get.dart';
import 'package:shopsage_auth_app/models/product.dart';
import 'package:shopsage_auth_app/services/product_service.dart';

class VendorController extends GetxController {
  final products = <Product>[].obs;

  // mock values for orders/revenue shown on dashboard
  final orders = 42.obs;
  final pendingOrders = 6.obs;
  final revenue = 2840.0.obs;

  @override
  void onInit() {
    super.onInit();
    products.assignAll(ProductService.instance.seedProducts());
  }

  void addProduct(Product p) {
    products.insert(0, p);
  }

  void updateProduct(String id, Product updated) {
    final idx = products.indexWhere((e) => e.id == id);
    if (idx != -1) products[idx] = updated;
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
  }

  int get totalProducts => products.length;

  List<Product> get lowStock => products.where((p) => p.stock <= 10).toList();
}

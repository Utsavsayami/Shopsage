import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> fetchProducts({int limit = 20}) async {
    final uri = Uri.parse('${ApiConfig.productsUrl}?limit=$limit&offset=0');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Could not load products: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final productsJson = _extractProductList(data);

    return productsJson
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<dynamic> _extractProductList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      if (data['products'] is List) {
        return data['products'] as List<dynamic>;
      }
      if (data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data['items'] is List) {
        return data['items'] as List<dynamic>;
      }
      if (data['docs'] is List) {
        return data['docs'] as List<dynamic>;
      }
    }

    throw Exception('Invalid product response structure: ${data.runtimeType}');
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';

class Product {
  final String id;
  final String name;
  final String type;
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}

class ProductService {
  final AuthHttpClient client;

  ProductService({required this.client});

  Future<List<Product>> getProductsByAccountId(String accountId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/api/v1/products/account/$accountId",
    );

    try {
      final response = await client.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        if (jsonResp is List) {
          return jsonResp.map<Product>((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw const FormatException('Expected list');
      } else if (response.statusCode == HttpStatus.notFound) {
        return <Product>[];
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}

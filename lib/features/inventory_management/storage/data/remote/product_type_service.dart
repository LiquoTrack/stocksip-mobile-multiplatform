import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_type_dto.dart';

/// Service class to handle product type-related API calls.
class ProductTypeService {
  final AuthHttpClient client;

  /// Constructs a [ProductTypeService] instance with the given [client].
  const ProductTypeService({required this.client});

  /// Fetches all product types from the API.
  /// Returns a list of [ProductTypeDto] instances upon successful retrieval.
  Future<List<ProductTypeDto>> getAllProductTypes() async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAllProductTypes(),
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = response.body;
        final List<dynamic> data = jsonDecode(json);
        return data.map((item) => ProductTypeDto.fromJson(item)).toList();
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching product types failed: $e');
    }
  }
}

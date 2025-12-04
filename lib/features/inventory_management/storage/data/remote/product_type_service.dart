import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_type_dto.dart';

/// Service class to handle product type-related API calls.
class ProductTypeService {

  /// Fetches all product types from the API.
  /// Returns a list of [ProductTypeDto] instances upon successful retrieval.
  Future<List<ProductTypeDto>> getAllProductTypes() async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAllProductTypes,
      );

      final response = await http.get(
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

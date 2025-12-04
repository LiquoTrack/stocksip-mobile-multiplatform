import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/brand_dto.dart';

/// Service class to handle brand-related API calls.
class BrandService {
  final AuthHttpClient client;

  /// Constructs a [BrandService] instance with the given [client].
  const BrandService({required this.client});

  /// Fetches all brands from the API.
  /// Returns a list of [BrandDto] instances upon successful retrieval.
  Future<List<BrandDto>> getAllBrands() async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAllBrands(),
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json as List).map((item) => BrandDto.fromJson(item)).toList();
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching brands failed: $e');
    }
  }
}
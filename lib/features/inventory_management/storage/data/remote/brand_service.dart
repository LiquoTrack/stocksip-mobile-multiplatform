import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/brand_dto.dart';

/// Service class to handle brand-related API calls.
class BrandService {

  /// Fetches all brands from the API.
  /// Returns a list of [BrandDto] instances upon successful retrieval.
  Future<List<BrandDto>> getAllBrands() async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAllBrands,
      );

      final response = await http.get(
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
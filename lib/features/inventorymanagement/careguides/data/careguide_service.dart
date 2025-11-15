import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stocksip/features/inventorymanagement/careguides/domain/careguide.dart';
import 'package:stocksip/core/constants/api_constants.dart';

class CareguideService {
  Future<List<CareGuideResponse>> getCareGuides({
    required String accountId,
  }) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: ApiConstants.getCareGuidesByAccountId(accountId),
      );

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        List maps = jsonDecode(response.body)['results'];
        return maps.map((json) => CareGuideResponse.fromJson(json)).toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('No careguides found (404)');
      }

      if (response.statusCode >= 500) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while fetching careguides: $e');
    }
  }
}
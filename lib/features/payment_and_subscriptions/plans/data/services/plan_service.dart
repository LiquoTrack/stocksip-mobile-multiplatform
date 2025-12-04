import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/constants/api_constants.dart';
import '../models/plan_dto.dart';
import 'dart:convert';

class PlanService {
  final AuthHttpClient client;

  const PlanService({required this.client});

  Future<List<PlanDto>> getAllPlans() async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getAllPlans,
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((item) => PlanDto.fromJson(item as Map<String, dynamic>)).toList();
      }

      throw Exception('Unexpected HTTP Status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Fetching plans failed: $e');
    }
  }
}

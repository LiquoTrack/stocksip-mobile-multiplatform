import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/data/models/alert_dto.dart';

class AlertsService {
  final AuthHttpClient client;

  const AlertsService({required this.client});

  Future<List<AlertDto>> getAlertsByAccountId({required String accountId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getAlertsByAccountId(accountId));

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> list = json as List<dynamic>;
        return list.map((e) => AlertDto.fromJson(e)).toList();
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Fetching alerts failed: $e');
    }
  }
}
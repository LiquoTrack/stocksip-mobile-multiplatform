import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/order_management/salesorder/data/remote/models/saleorder_dto.dart';

class SaleorderService {
  final AuthHttpClient client;

  SaleorderService({required this.client});

  Future<SaleorderDto> createFromProcurement(String purchaseOrderId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}orders/from-procurement/$purchaseOrderId",
    );

    try {
      final response = await client.post(
        uri,
        headers: {HttpHeaders.acceptHeader: ContentType.json.mimeType},
      );

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        return SaleorderDto.fromJson((jsonResp as Map).cast<String, dynamic>());
      } else if (response.statusCode == HttpStatus.notFound) {
        throw Exception('Purchase Order not found');
      } else if (response.statusCode == HttpStatus.badRequest) {
        throw Exception('Invalid request');
      } else {
        throw Exception('Failed to create sales order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating sales order: $e');
    }
  }
}
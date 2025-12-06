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

  Future<List<SaleorderDto>> getAllOrders({String? accountId}) async {
    final uri = accountId != null 
        ? Uri.parse("${ApiConstants.baseUrl}orders?accountId=$accountId")
        : Uri.parse("${ApiConstants.baseUrl}orders");

    try {
      print('>>> [SaleorderService] GET $uri');
      final response = await client.get(
        uri,
        headers: {HttpHeaders.acceptHeader: ContentType.json.mimeType},
      );

      print('>>> [SaleorderService] Status: ${response.statusCode}');
      print('>>> [SaleorderService] Response: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        
        List<SaleorderDto> orders = [];
        
        if (jsonResp is List) {
          print('>>> [SaleorderService] Total orders from API: ${jsonResp.length}');
          orders = jsonResp
              .map((e) => SaleorderDto.fromJson((e as Map).cast<String, dynamic>()))
              .toList();
        } else if (jsonResp is Map && jsonResp.containsKey('data')) {
          final data = jsonResp['data'];
          if (data is List) {
            print('>>> [SaleorderService] Total orders from API: ${data.length}');
            orders = data
                .map((e) => SaleorderDto.fromJson((e as Map).cast<String, dynamic>()))
                .toList();
          }
        }
        

        if (accountId != null) {
          final filteredOrders = orders.where((order) {
            final matches = order.supplierId == accountId;
            print('>>> [SaleorderService] Order ${order.orderCode}: supplierId=${order.supplierId}, accountId=$accountId, matches=$matches');
            return matches;
          }).toList();
          print('>>> [SaleorderService] Filtered orders count: ${filteredOrders.length} (from ${orders.length})');
          return filteredOrders;
        }
        
        print('>>> [SaleorderService] Orders count: ${orders.length}');
        return orders;
      } else if (response.statusCode == HttpStatus.unauthorized) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      print('>>> [SaleorderService] Error: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<void> confirmOrder(String orderId) async {
    await _updateOrderStatus(orderId, "confirm");
  }

  Future<void> receiveOrder(String orderId) async {
    await _updateOrderStatus(orderId, "receive");
  }

  Future<void> shipOrder(String orderId) async {
    await _updateOrderStatus(orderId, "ship");
  }

  Future<void> cancelOrder(String orderId) async {
    await _updateOrderStatus(orderId, "cancel");
  }

  Future<void> _updateOrderStatus(String orderId, String action) async {
    final uri = Uri.parse("${ApiConstants.baseUrl}orders/$orderId/$action");
    
    try {
      print(">>> [SaleorderService] PUT $uri");
      final response = await client.put(
        uri,
        headers: {HttpHeaders.acceptHeader: ContentType.json.mimeType},
      );

      print(">>> [SaleorderService] Status update response: ${response.statusCode}");
      
      if (response.statusCode == 204) {
        print(">>> [SaleorderService] Order $orderId marked as $action");
      } else if (response.statusCode == HttpStatus.unauthorized) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == HttpStatus.notFound) {
        throw Exception("Order not found");
      } else {
        throw Exception("Failed to update order: ${response.statusCode}");
      }
    } catch (e) {
      print(">>> [SaleorderService] Error updating order status: $e");
      throw Exception("Error updating order status: $e");
    }
  }
}

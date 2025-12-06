import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_addition_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_response_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_subtrack_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_transfer_request_dto.dart';

/// Service class to handle inventory-related API calls.
class InventoryService {

  final AuthHttpClient client;

  const InventoryService({required this.client});

  /// Fetches all inventories associated with the given [warehouseId].
  /// Returns a list of [InventoryResponseDto] instances upon successful retrieval.
  Future<List<InventoryResponseDto>> getAllInventoriesByWarehouseId({required String warehouseId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getInventoriesByWarehouseId(warehouseId));

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> inventoriesJson = json as List<dynamic>;
        return inventoriesJson.map((e) => InventoryResponseDto.fromJson(e)).toList();
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching inventories failed: $e');
    }
  }

  /// Fetches inventory by [productId] and [warehouseId].
  /// Returns an [InventoryResponseDto] instance upon successful retrieval.
  Future<InventoryResponseDto> getInventoryByProductIdAndWarehouseId({required String productId, required String warehouseId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getInventoryByProductIdAndWarehouseId(productId, warehouseId));

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return InventoryResponseDto.fromJson(json);
      }
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching inventory failed: $e');
    }
  }

  /// Adds products to the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponseDto] instance representing the updated or created inventory.
  Future<InventoryResponseDto> addProductsToWarehouseInventory({required String warehouseId, required String productId, required InventoryAdditionRequestDto request}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.addProductsToWarehouseInventory(warehouseId, productId));

      final response = await client.post( 
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return InventoryResponseDto.fromJson(json);
      } 
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Adding products to inventory failed: $e');
    }
  }

  /// Subtracts products from the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  Future<InventoryResponseDto> subtractProductsFromWarehouseInventory({required String warehouseId, required String productId, required InventorySubtrackRequestDto request}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.subtractProductsFromWarehouseInventory(warehouseId, productId));

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toMap()),
      );  

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return InventoryResponseDto.fromJson(json);
      } 
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');

    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Subtracting products from inventory failed: $e');
    }
  }

  /// Transfers products from one warehouse to another identified by [fromWarehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponseDto] instance representing the updated origin inventory.
  Future<InventoryResponseDto> transferProductsToAnotherWarehousee({required String fromWarehouseId, required String productId, required InventoryTransferRequestDto request}) async {
    try {

      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.transferProductsBetweenWarehouses(fromWarehouseId, productId));

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toMap()),
      );  

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return InventoryResponseDto.fromJson(json);
      } 
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Transferring products to another warehouse failed: $e');
    }
  }

  /// Fetches inventory by its unique [inventoryId].
  /// Returns an [InventoryResponseDto] instance upon successful retrieval.
  Future<InventoryResponseDto> getInventoryById({required String inventoryId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getInventoryById(inventoryId));

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return InventoryResponseDto.fromJson(json);
      }
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');

    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching inventory by ID failed: $e');
    }
  }

  /// Deletes inventory identified by [inventoryId].
  Future<void> deleteInventoryById({required String inventoryId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteInventoryById(inventoryId));

      final response = await client.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Deleting inventory by ID failed: $e');
    }
  }
}
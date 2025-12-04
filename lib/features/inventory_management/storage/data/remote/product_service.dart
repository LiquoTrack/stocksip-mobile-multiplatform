import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_response_dto.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_update_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/products_with_count_dto.dart';

/// Service class to handle product-related API calls.
class ProductService {
  final AuthHttpClient client;

  const ProductService({required this.client});

  /// Fetches products associated with the given [accountId].
  /// Returns a list of [ProductsWithCountDto] instances upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductsWithCountDto> getProductsByAccountId({
    required String accountId,
  }) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getProductsByAccountId(accountId),
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductsWithCountDto.fromJson(json);
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching products failed: $e');
    }
  }

  /// Fetches products by warehouse ID.
  /// Returns a list of [ProductResponseDto] instances for the warehouse inventory.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<List<ProductResponseDto>> getProductsByWarehouseId({
    required String warehouseId,
  }) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getInventoriesByWarehouseId(warehouseId),
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((item) => ProductResponseDto.fromJson(item)).toList();
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching warehouse products failed: $e');
    }
  }

  /// Fetches a product by its [productId].
  /// Returns a [ProductResponseDto] instance upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponseDto> getProductById({required String productId}) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getProductById(productId),
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponseDto.fromJson(json);
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching product failed: $e');
    }
  }

  /// Registers a new product using the provided [request] details for the given [accountId].
  /// Returns a [ProductResponseDto] instance upon successful registration.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponseDto> registerProduct({
    required String accountId,
    required ProductRequestDto dto,
  }) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.registerProduct(accountId),
      );

      /// Create multipart request
      var request = http.MultipartRequest('POST', uri);

      request.fields['Name'] = dto.name;
      request.fields['Type'] = dto.type;
      request.fields['Brand'] = dto.brand;
      request.fields['UnitPrice'] = dto.unitPrice.toString();
      request.fields['Code'] = dto.code;
      request.fields['MinimumStock'] = dto.minimumStock.toString();
      request.fields['Content'] = dto.content.toString();
      request.fields['SupplierId'] = dto.supplierId ?? 'string';

      if (dto.imageFile != null) {
        var stream = http.ByteStream(dto.imageFile!.openRead());
        var length = await dto.imageFile!.length();
        var multipartFile = http.MultipartFile(
          'Image',
          stream,
          length,
          filename: basename(dto.imageFile!.path),
        );
        request.files.add(multipartFile);
      }

      /// Send request
      final sendRequest = await client.sendMultipart(request);

      /// Get the response
      final response = await http.Response.fromStream(sendRequest);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return ProductResponseDto.fromJson(jsonDecode(response.body));
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Registering product failed: $e');
    }
  }

  /// Updates an existing product identified by [productId] using the provided [request] details.
  /// Returns a [ProductResponseDto] instance upon successful update.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponseDto> updateProduct({
    required String productId,
    required ProductUpdateRequestDto dto,
  }) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.updateProduct(productId),
      );

      /// Create multipart request
      var request = http.MultipartRequest('POST', uri);

      request.fields['Name'] = dto.name;
      request.fields['UnitPrice'] = dto.unitPrice.toString();
      request.fields['MoneyCode'] = dto.code;
      request.fields['MinimumStock'] = dto.minimumStock.toString();
      request.fields['Content'] = dto.content.toString();

      if (dto.imageFile != null) {
        var stream = http.ByteStream(dto.imageFile!.openRead());
        var length = await dto.imageFile!.length();
        var multipartFile = http.MultipartFile(
          'Image',
          stream,
          length,
          filename: basename(dto.imageFile!.path),
        );
        request.files.add(multipartFile);
      }

      /// Send request
      final sendRequest = await client.sendMultipart(request);

      /// Get the response
      final response = await http.Response.fromStream(sendRequest);

      if (response.statusCode == HttpStatus.ok) {
        return ProductResponseDto.fromJson(jsonDecode(response.body));
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Updating product failed: $e');
    }
  }

  /// Deletes a product by its [productId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<void> deleteProductById({required String productId}) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getProductById(productId),
      );

      final http.Response response = await client.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return;
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Deleting product failed: $e');
    }
  }
}

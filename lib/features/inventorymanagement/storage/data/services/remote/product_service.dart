import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_request.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_response.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_update_request.dart';

/// Service class to handle product-related API calls.
class ProductService {

  /// Fetches products associated with the given [accountId].
  /// Returns a list of [ProductResponse] instances upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<List<ProductResponse>> getProductsByAccountId({required String accountId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getProductsByAccountId(accountId));

      final http.Response response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json as List).map((item) => ProductResponse.fromJson(item)).toList();
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

  /// Fetches a product by its [productId].
  /// Returns a [ProductResponse] instance upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponse> getProductById({required String productId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getProductById(productId));

      final http.Response response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponse.fromJson(json);
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
  /// Returns a [ProductResponse] instance upon successful registration.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponse> registerProduct({
    required String accountId, 
    required ProductRequest request
  }) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.registerProduct(accountId));

      /// Create multipart request
      final multipartRequest = http.MultipartRequest('POST', uri);

      /// Add other fields from ProductRequest
      multipartRequest.fields.addAll(request.toFields());

      /// Attach image file
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'Image',
          request.image.path
        ),
      );

      /// Send request
      final streamedResponse = await multipartRequest.send();

      /// Get the response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        return ProductResponse.fromJson(jsonDecode(response.body));
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
  /// Returns a [ProductResponse] instance upon successful update.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<ProductResponse> updateProduct({
    required String productId, 
    required ProductUpdateRequest request
  }) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateProduct(productId));

      /// Create multipart request
      final multipartRequest = http.MultipartRequest('PUT', uri);

      /// Add other fields from ProductRequest
      multipartRequest.fields.addAll(request.toFields());

      /// Attach image file
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'Image',
          request.image.path
        ),
      );

      /// Send request
      final streamedResponse = await multipartRequest.send();

      /// Get the response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        return ProductResponse.fromJson(jsonDecode(response.body));
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
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getProductById(productId));

      final http.Response response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'}
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
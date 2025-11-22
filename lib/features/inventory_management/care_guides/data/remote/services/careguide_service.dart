import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_request.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service class to handle care guide-related API calls.
class CareguideService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, String>> _authHeaders({Map<String, String>? extra}) async {
    final token = await _storage.read(key: 'token');
    final base = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      base['Authorization'] = 'Bearer $token';
    }
    if (extra != null) base.addAll(extra);
    return base;
  }

  /// Gets a care guide by its [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<CareguideResponse> getById({required String careGuideId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getCareGuideById(careGuideId));

      final http.Response response = await http.get(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CareguideResponse.fromJson(json);
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching care guide failed: $e');
    }
  }

  /// Gets all care guides by account ID.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<List<CareguideResponse>> getAllCareGuideByAccountId({required String accountId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getCareGuidesByAccountId(accountId));

      final http.Response response = await http.get(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody is List) {
          return jsonBody.map<CareguideResponse>((e) => CareguideResponse.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw const FormatException('Expected list response');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching care guides failed: $e');
    }
  }

  /// Creates a new care guide.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<CareguideResponse> createCareGuide({required CareGuideRequest request}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.createCareGuide(request.accountId));

      final multipartRequest = http.MultipartRequest('POST', uri);
      multipartRequest.fields.addAll(request.toFields());
      multipartRequest.headers.addAll(await _authHeaders());

      if (request.fileData != null && (request.fileName ?? '').isNotEmpty) {
        multipartRequest.files.add(
          http.MultipartFile.fromBytes(
            'File',
            request.fileData!,
            filename: request.fileName!,
            contentType: request.fileContentType != null ? MediaType.parse(request.fileContentType!) : null,
          ),
        );
      }

      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return CareguideResponse.fromJson(json);
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Creating care guide failed: $e');
    }
  }

  /// Updates a care guide by its [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<CareguideResponse> updateCareGuide({required String careGuideId, required CareGuideRequest request}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateCareGuide(careGuideId));

      final multipartRequest = http.MultipartRequest('PUT', uri);
      multipartRequest.fields.addAll(request.toFields());
      multipartRequest.headers.addAll(await _authHeaders());

      if (request.fileData != null && (request.fileName ?? '').isNotEmpty) {
        multipartRequest.files.add(
          http.MultipartFile.fromBytes(
            'File',
            request.fileData!,
            filename: request.fileName!,
            contentType: request.fileContentType != null ? MediaType.parse(request.fileContentType!) : null,
          ),
        );
      }

      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return CareguideResponse.fromJson(json);
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Updating care guide failed: $e');
    }
  }

  /// Deletes a care guide by its [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<void> deleteCareGuide({required String careGuideId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteCareGuide(careGuideId));

      final http.Response response = await http.delete(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        return;
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Deleting care guide failed: $e');
    }
  }

  /// Gets a list of care guides by product type.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<List<CareguideResponse>> getCareGuideByProductType({required String accountId, required String productType}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getCareGuideByProductType(accountId, productType));

      final http.Response response = await http.get(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json is List) {
          return json.map<CareguideResponse>((e) => CareguideResponse.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw const FormatException('Expected list response');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Fetching care guides by product type failed: $e');
    }
  }

  /// Unassigns a care guide by its [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<void> unassignCareGuide({required String careGuideId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.unassignCareGuide(careGuideId));

      final http.Response response = await http.delete(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        return;
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Unassigning care guide failed: $e');
    }
  }

  /// Assigns a care guide to a product by its [careGuideId] and [productId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<void> assignCareGuide({required String careGuideId, required String productId}) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.assignCareGuide(careGuideId, productId));

      final http.Response response = await http.post(
        uri,
        headers: await _authHeaders(),
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        return;
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Assigning care guide failed: $e');
    }
  }
}
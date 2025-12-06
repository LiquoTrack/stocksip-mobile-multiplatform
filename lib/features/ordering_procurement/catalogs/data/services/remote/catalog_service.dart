import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import '../../../domain/models/catalog.dart';
import '../../remote/models/catalog_dto.dart';
import '../../remote/models/create_catalog_request.dart';
import '../../remote/models/update_catalog_request.dart';
import '../../remote/models/add_catalog_item_request.dart';
import '../../remote/models/supplier_info_dto.dart';
import '../../remote/models/mappers.dart';

/// Service class to handle catalog-related API calls
class CatalogService {
  static const String _tokenKey = 'token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Fetches all catalogs
  Future<List<Catalog>> getAllCatalogs() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs',
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => CatalogDto.fromJson(item as Map<String, dynamic>).toDomain())
            .toList();
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to fetch catalogs: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to fetch catalogs: $e');
    }
  }

  /// Fetches all published catalogs
  Future<List<Catalog>> getPublishedCatalogs() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/published',
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => CatalogDto.fromJson(item as Map<String, dynamic>).toDomain())
            .toList();
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to fetch published catalogs: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to fetch published catalogs: $e');
    }
  }

  /// Fetches all catalogs by account ID
  Future<List<Catalog>> getCatalogsByAccountId(String accountId) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}accounts/$accountId/catalogs',
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => CatalogDto.fromJson(item as Map<String, dynamic>).toDomain())
            .toList();
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to fetch catalogs: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to fetch catalogs: $e');
    }
  }

  /// Fetches account with associated catalogs
  Future<SupplierInfo> getAccountWithCatalogs(String accountId) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/with-business?accountId=$accountId',
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return SupplierInfoDto.fromJson(json).toDomain();
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to fetch account with catalogs: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to fetch account with catalogs: $e');
    }
  }

  /// Fetches a single catalog by ID
  Future<Catalog> getCatalogById(String catalogId) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse('${ApiConstants.baseUrl}catalogs/$catalogId');

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return CatalogDto.fromJson(json).toDomain();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Catalog not found (404)');
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to fetch catalog: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to fetch catalog: $e');
    }
  }

  /// Creates a new catalog
  Future<Catalog> createCatalog({
    required String accountId,
    required String name,
    required String description,
    required String contactEmail,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}accounts/$accountId/catalogs',
      );

      final request = CreateCatalogRequest(
        name: name,
        description: description,
        contactEmail: contactEmail,
      );

      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body);
        return CatalogDto.fromJson(json).toDomain();
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to create catalog: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to create catalog: $e');
    }
  }

  /// Updates an existing catalog
  Future<Catalog> updateCatalog({
    required String catalogId,
    required String name,
    required String description,
    required String contactEmail,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/$catalogId',
      );

      final request = UpdateCatalogRequest(
        name: name,
        description: description,
        contactEmail: contactEmail,
      );

      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.noContent) {
        // Need to fetch the updated catalog
        return await getCatalogById(catalogId);
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Failed to update catalog: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to update catalog: $e');
    }
  }

  /// Adds an item to a catalog
  Future<Catalog> addCatalogItem({
    required String catalogId,
    required String productId,
    required String warehouseId,
    required int stock,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/$catalogId/items',
      );

      final request = AddCatalogItemRequest(
        productId: productId,
        warehouseId: warehouseId,
        stock: stock,
      );

      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final json = jsonDecode(response.body);
        return CatalogDto.fromJson(json).toDomain();
      }

      throw HttpException('Failed to add catalog item: ${response.statusCode} - ${response.body}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to add catalog item: $e');
    }
  }

  /// Removes an item from a catalog
  Future<Catalog> removeCatalogItem({
    required String catalogId,
    required String productId,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/$catalogId/items/$productId',
      );

      final http.Response response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.noContent) {
        // Fetch the updated catalog after deletion
        return await getCatalogById(catalogId);
      }

      throw HttpException('Failed to remove catalog item: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to remove catalog item: $e');
    }
  }

  /// Publishes a catalog
  Future<void> publishCatalog(String catalogId) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/$catalogId/publications',
      );

      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw HttpException('Failed to publish catalog: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to publish catalog: $e');
    }
  }

  /// Unpublishes a catalog
  Future<void> unpublishCatalog(String catalogId) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}catalogs/$catalogId/publications',
      );

      final http.Response response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw HttpException('Failed to unpublish catalog: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to unpublish catalog: $e');
    }
  }
}

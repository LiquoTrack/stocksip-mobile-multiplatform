import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_dto.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_request_dto.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_wrapper_dto.dart';

class CareguideService {
  final AuthHttpClient client;

  CareguideService({required this.client});

  Future<CareguideWrapperDto> getCareGuidesByAccountId(String accountId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.getCareGuidesByAccountId(accountId)}",
    );

    try {
      final response = await client.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        return CareguideWrapperDto.fromJson(jsonResp);
      } else if (response.statusCode == HttpStatus.notFound) {
        return const CareguideWrapperDto(count: 0, careGuides: []);
      } else {
        throw Exception('Failed to load care guides: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching care guides: $e');
    }
  }

  Future<CareguideDto> getById(String careGuideId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.getCareGuideById(careGuideId)}",
    );

    try {
      final response = await client.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        return CareguideDto.fromJson(jsonResp);
      } else {
        throw Exception('Failed to get care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting care guide: $e');
    }
  }

  Future<CareguideDto> createCareGuide(String accountId, CareguideRequestDto dto) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.createCareGuide(accountId)}",
    );
    try {
      final response = await client.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final jsonResp = jsonDecode(response.body);
        return CareguideDto.fromJson(jsonResp);
      } else {
        throw Exception('Failed to create care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating care guide: $e');
    }
  }

  Future<CareguideDto> updateCareGuide(String careGuideId, CareguideRequestDto dto) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.updateCareGuide(careGuideId)}",
    );
    try {
      final response = await client.put(
        uri,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode(dto.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        return CareguideDto.fromJson(jsonResp);
      } else {
        throw Exception('Failed to update care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating care guide: $e');
    }
  }

  Future<CareguideDto> updateCareGuideWithBody(String careGuideId, Map<String, dynamic> requestBody) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.updateCareGuide(careGuideId)}",
    );
    try {
      final response = await client.put(
        uri,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        return CareguideDto.fromJson(jsonResp);
      } else {
        throw Exception('Failed to update care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating care guide: $e');
    }
  }

  Future<bool> deleteCareGuide(String careGuideId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.deleteCareGuide(careGuideId)}",
    );
    try {
      final response = await client.delete(uri);
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        return true;
      } else if (response.statusCode == HttpStatus.notFound) {
        return false;
      } else {
        throw Exception('Failed to delete care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting care guide: $e');
    }
  }

  Future<List<CareguideDto>> getCareGuideByProductType(String accountId, String productType) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.getCareGuideByProductType(accountId, productType)}",
    );
    try {
      final response = await client.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final jsonResp = jsonDecode(response.body);
        if (jsonResp is List) {
          return jsonResp.map<CareguideDto>((e) => CareguideDto.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw const FormatException('Expected list');
      } else if (response.statusCode == HttpStatus.notFound) {
        return <CareguideDto>[];
      } else {
        throw Exception('Failed to load care guides by product type: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching care guides by product type: $e');
    }
  }

  Future<bool> unassignCareGuide(String careGuideId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.unassignCareGuide(careGuideId)}",
    );
    try {
      final response = await client.delete(uri);
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        return true;
      } else {
        throw Exception('Failed to unassign care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error unassigning care guide: $e');
    }
  }

  Future<bool> assignCareGuide(String careGuideId, String productId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.assignCareGuide(careGuideId, productId)}",
    );
    try {
      final response = await client.put(uri);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      } else {
        throw Exception('Failed to assign care guide: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning care guide: $e');
    }
  }
}
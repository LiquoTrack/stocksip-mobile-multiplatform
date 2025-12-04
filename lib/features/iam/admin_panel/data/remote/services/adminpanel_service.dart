import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/models/adminpanel_request_dto.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/models/adminpanel_subuser_wrapper_dto.dart';

class AdminPanelService {
  final AuthHttpClient client;

  AdminPanelService({required this.client});

  Future<bool> registerSubUser(String accountId, SubUserRequestDto dto) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}accounts/$accountId/users",
    );

    try {
      final response = await client.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return true;
      }
      if (response.statusCode == HttpStatus.badRequest) {
        return false;
      }
      throw Exception('Failed to register sub user: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error registering sub user: $e');
    }
  }

  Future<bool> deleteUser(String userId, String profileId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}users/$userId",
    );

    try {
      final req = http.Request('DELETE', uri);
      req.headers[HttpHeaders.contentTypeHeader] = ContentType.json.mimeType;
      req.body = jsonEncode({'profileId': profileId});
      final streamed = await client.send(req);
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        return true;
      }
      if (response.statusCode == HttpStatus.notFound) {
        return false;
      }
      throw Exception('Failed to delete user: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<SubUserWrapperDto>> getSubUsers(
    String accountId, {
    String? role,
  }) async {
    final base = "${ApiConstants.baseUrl}accounts/$accountId/users";
    final qp = <String, String>{};
    if (role != null && role.isNotEmpty && role != 'All') {
      qp['role'] = role;
    }
    final uri = Uri.parse(base).replace(queryParameters: qp.isEmpty ? null : qp);

    try {
      final response = await client.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return SubUserWrapperDto.listFromJson(jsonResponse);
        } else if (jsonResponse is Map<String, dynamic>) {
          return [SubUserWrapperDto.fromJson(jsonResponse)];
        }
        return <SubUserWrapperDto>[];
      }

      if (response.statusCode == HttpStatus.notFound) {
        return <SubUserWrapperDto>[];
      }
      throw Exception('Failed to load users: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
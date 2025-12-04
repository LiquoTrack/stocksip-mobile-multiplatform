import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/profile_management/profiles/domain/profile.dart';

/// Service class to handle profile-related API calls.
class ProfileService {
  static const String _tokenKey = 'token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Fetches the user's profile information.
  /// Returns a [Profile] instance upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<Profile> getProfile() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.getMyProfile);

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Profile.fromJson(json);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Profile not found (404)');
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      if (response.statusCode >= HttpStatus.internalServerError) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Updates the user's profile information.
  /// Returns a [Profile] instance upon successful update.
  /// Throws an [HttpException] for non-200 HTTP responses.
  Future<Profile> updateProfile({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateProfile(profileId));

      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'assignedRole': assignedRole,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Profile.fromJson(json);
      }

      if (response.statusCode == HttpStatus.badRequest) {
        throw HttpException('Bad request (400)');
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      if (response.statusCode >= HttpStatus.internalServerError) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Uploads a profile picture for the user.
  /// Returns a URL of the uploaded image upon successful upload.
  /// Throws an [HttpException] for non-200 HTTP responses.
  Future<String> uploadProfilePicture({
    required String profileId,
    required String imagePath,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateProfile(profileId));

      final http.MultipartRequest request = http.MultipartRequest(
        'PUT',
        uri,
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['FirstName'] = ''
        ..fields['LastName'] = ''
        ..fields['PhoneNumber'] = ''
        ..fields['AssignedRole'] = ''
        ..files.add(
          await http.MultipartFile.fromPath('ProfilePicture', imagePath),
        );

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        return json['profilePictureUrl'] as String;
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      if (response.statusCode >= HttpStatus.internalServerError) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}

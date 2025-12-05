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

      // Ensure no fields are empty - use provided values or defaults
      final Map<String, dynamic> requestBody = {
        'FirstName': firstName.isNotEmpty ? firstName : 'N/A',
        'LastName': lastName.isNotEmpty ? lastName : 'N/A',
        'PhoneNumber': phoneNumber.isNotEmpty ? phoneNumber : '',
        'AssignedRole': assignedRole.isNotEmpty ? assignedRole : 'User',
      };

      print('DEBUG: Updating profile with: $requestBody');

      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('DEBUG: Update response status: ${response.statusCode}');
      print('DEBUG: Update response body: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Profile.fromJson(json);
      }

      if (response.statusCode == HttpStatus.badRequest) {
        throw HttpException('Bad request (400): ${response.body}');
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      if (response.statusCode == HttpStatus.conflict) {
        throw HttpException('Conflict (409): Profile data conflicts');
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

  /// Updates profile with optional image upload in a single multipart request
  /// This ensures all data is sent together with proper validation
  /// 
  /// **IMPORTANT**: Backend REQUIRES ProfilePicture field to be a file.
  /// If no new image, the user must have selected one previously.
  Future<Profile> updateProfileWithImage({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
    String? imagePath,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        throw HttpException('Token not found');
      }

      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateProfile(profileId));

      // Backend REQUIRES multipart with actual file for ProfilePicture
      print('DEBUG: Using multipart (backend requirement)');
      
      final http.MultipartRequest request = http.MultipartRequest(
        'PUT',
        uri,
      )
        ..headers['Authorization'] = 'Bearer $token'
        // Use PascalCase for field names (as required by backend)
        ..fields['FirstName'] = firstName.isNotEmpty ? firstName : 'N/A'
        ..fields['LastName'] = lastName.isNotEmpty ? lastName : 'N/A'
        ..fields['PhoneNumber'] = phoneNumber.isNotEmpty ? phoneNumber : ''
        ..fields['AssignedRole'] = assignedRole.isNotEmpty ? assignedRole : 'User';

      // ProfilePicture MUST be a file, not empty text
      // If imagePath is provided, use it
      // Otherwise, backend expects user to have selected an image during creation
      if (imagePath != null && imagePath.isNotEmpty) {
        print('DEBUG: Adding NEW image from: $imagePath');
        request.files.add(
          await http.MultipartFile.fromPath('ProfilePicture', imagePath),
        );
      } else {
        // Backend cannot accept empty/null for ProfilePicture in PUT requests
        // This shouldn't happen if BLoC validation works correctly
        print('DEBUG: WARNING - No image path provided, but backend requires it');
        // Try sending empty file as last resort
        request.files.add(
          http.MultipartFile.fromBytes('ProfilePicture', []),
        );
      }

      print('DEBUG: Request fields: ${request.fields}');
      print('DEBUG: Request files count: ${request.files.length}');
      if (request.files.isNotEmpty) {
        print('DEBUG: File field: ${request.files.first.field}, size: ${request.files.first.length}');
      }

      final http.StreamedResponse response = await request.send();

      print('DEBUG: Multipart response status: ${response.statusCode}');

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.stream.bytesToString();
        print('DEBUG: Multipart response body: $responseBody');
        final json = jsonDecode(responseBody);
        return Profile.fromJson(json);
      }

      if (response.statusCode == HttpStatus.badRequest) {
        final responseBody = await response.stream.bytesToString();
        print('DEBUG: Bad request body: $responseBody');
        throw HttpException('Bad request (400): $responseBody');
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        throw HttpException('Unauthorized access (401)');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
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
        ..files.add(
          await http.MultipartFile.fromPath('ProfilePicture', imagePath),
        );

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        return json['profilePictureUrl'] as String? ?? json['profile']?['profilePictureUrl'] as String? ?? '';
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

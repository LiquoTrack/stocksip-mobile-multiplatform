import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/features/iam/login/domain/user.dart';
import 'package:http/http.dart' as http;

class AuthService {

  /// Logs in a user with the provided [email] and [password].
  /// Returns a [User] instance upon successful login.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  Future<User> login(String email, String password) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.signIn);

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return User.fromJson(json);
      }
      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
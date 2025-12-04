import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:stocksip/features/iam/password_recovery/data/remote/models/recovery_code_response.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/models/reset_password_request_dto.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/models/send_email_request_dto.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/models/verify_recovery_code_request_dto.dart';

class RecoveryPasswordService {
  Future<RecoveryCodeResponse> sendRecoveryEmail(SendEmailRequestDto requestDto) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.sendRecoveryCode(),
      );

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': requestDto.email}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return RecoveryCodeResponse.fromJson(json);
      } else {
        throw Exception('Failed to send recovery email. Status code: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('Failed to send recovery email: $e');
    }
  }

  Future<RecoveryCodeResponse> verifyRecoveryCode(VerifyRecoveryCodeRequestDto requestDto) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.verifyRecoveryCode(),
      );

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': requestDto.email, 'code': requestDto.code}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return RecoveryCodeResponse.fromJson(json);
      } else {
        throw Exception('Failed to verify recovery code. Status code: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('Failed to verify recovery code: $e');
    }
  }

  Future<RecoveryCodeResponse> resetPassword(ResetPasswordRequestDto requestDto) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.resetPassword(),
      );

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': requestDto.email, 'newPassword': requestDto.newPassword}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return RecoveryCodeResponse.fromJson(json);
      } else {
        throw Exception('Failed to reset password. Status code: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}

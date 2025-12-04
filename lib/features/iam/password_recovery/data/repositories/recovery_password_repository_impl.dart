import 'package:stocksip/features/iam/password_recovery/data/remote/models/reset_password_request_dto.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/models/send_email_request_dto.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/models/verify_recovery_code_request_dto.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/service/recovery_password_service.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/message.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';
import 'package:stocksip/features/iam/password_recovery/domain/repositories/recovery_password_repository.dart';

class RecoveryPasswordRepositoryImpl implements RecoveryPasswordRepository {

  final RecoveryPasswordService service;

  RecoveryPasswordRepositoryImpl({required this.service});

  @override
  Future<Message> resetPassword(ResetPassword resetPassword) async {
    try {
      final resetPasswordRequest = ResetPasswordRequestDto(
        email: resetPassword.email,
        newPassword: resetPassword.newPassword,
      );
      final response = await service.resetPassword(resetPasswordRequest);
      return response.toDomain();
    } catch (e) {
      throw Exception('Error resetting password: $e');      
    }
  }

  @override
  Future<Message> sendRecoveryEmail(SendEmail sendEmail) async {
    try {
      final sendEmailRequest = SendEmailRequestDto(email: sendEmail.email);
      final response = await service.sendRecoveryEmail(sendEmailRequest);
      return response.toDomain();
    } catch (e) {
      throw Exception('Error sending recovery email: $e');      
    }
  }

  @override
  Future<Message> verifyRecoveryCode(VerifyCode verifyCode) async {
    try {
      final verifyCodeRequest = VerifyRecoveryCodeRequestDto(email: verifyCode.email, code: verifyCode.code);
      final response = await service.verifyRecoveryCode(verifyCodeRequest);
      return response.toDomain();
    } catch (e) {
      throw Exception('Error verifying recovery code: $e');      
    }
  }
}
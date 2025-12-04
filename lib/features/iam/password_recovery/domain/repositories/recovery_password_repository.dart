import 'package:stocksip/features/iam/password_recovery/domain/models/message.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';

abstract class RecoveryPasswordRepository {

  Future<Message> sendRecoveryEmail(SendEmail sendEmail);

  Future<Message> verifyRecoveryCode(VerifyCode verifyCode);

  Future<Message> resetPassword(ResetPassword resetPassword);
}
import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';

abstract class RecoveryPasswordEvent {
  const RecoveryPasswordEvent();
}

class SendRecoveryEmailEvent extends RecoveryPasswordEvent {
  final SendEmail email;
  const SendRecoveryEmailEvent({required this.email});
}

class VerifyRecoveryCodeEvent extends RecoveryPasswordEvent {
  final VerifyCode verifyCode;

  const VerifyRecoveryCodeEvent({required this.verifyCode});
}

class ResetPasswordEvent extends RecoveryPasswordEvent {
  final ResetPassword resetPassword;

  const ResetPasswordEvent({required this.resetPassword});
}
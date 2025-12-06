import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';

class RecoveryPasswordState {
  final Status status;
  final SendEmail? sendEmail;
  final VerifyCode? verifyCode;
  final ResetPassword? resetPassword;
  final String? message;

  const RecoveryPasswordState({
    this.status = Status.initial,
    this.sendEmail,
    this.verifyCode,
    this.resetPassword,
    this.message,
  });

  RecoveryPasswordState copyWith({
    Status? status,
    SendEmail? sendEmail,
    VerifyCode? verifyCode,
    ResetPassword? resetPassword,
    String? message,
  }) {
    return RecoveryPasswordState(
      status: status ?? this.status,
      sendEmail: sendEmail ?? this.sendEmail,
      verifyCode: verifyCode ?? this.verifyCode,
      resetPassword: resetPassword ?? this.resetPassword,
      message: message ?? this.message,
    );
  }
}

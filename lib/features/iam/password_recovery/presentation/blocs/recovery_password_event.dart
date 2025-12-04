abstract class RecoveryPasswordEvent {
  const RecoveryPasswordEvent();
}

class SendRecoveryEmailEvent extends RecoveryPasswordEvent {
  final String email;
  const SendRecoveryEmailEvent({required this.email});
}

class VerifyRecoveryCodeEvent extends RecoveryPasswordEvent {
  final String email;
  final String code;
  const VerifyRecoveryCodeEvent({required this.email, required this.code});
}

class ResetPasswordEvent extends RecoveryPasswordEvent {
  final String email;
  final String resetPassword;

  const ResetPasswordEvent({required this.email, required this.resetPassword});
}
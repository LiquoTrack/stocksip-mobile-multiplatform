import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';

class ResetPasswordRequestDto {
  final String email;
  final String newPassword;

  const ResetPasswordRequestDto({
    required this.email,
    required this.newPassword,
  });

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestDto(
      email: json['email'] as String,
      newPassword: json['newPassword'] as String,
    );
  }

  ResetPassword toDomain() {
    return ResetPassword(
      email: email,
      newPassword: newPassword,
    );
  }
}

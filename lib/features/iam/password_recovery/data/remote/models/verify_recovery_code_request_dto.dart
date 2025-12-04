import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';

class VerifyRecoveryCodeRequestDto {
  final String email;
  final String code;

  const VerifyRecoveryCodeRequestDto({
    required this.email,
    required this.code,
  });

  factory VerifyRecoveryCodeRequestDto.fromJson(Map<String, dynamic> json) {
    return VerifyRecoveryCodeRequestDto(
      email: json['email'] as String,
      code: json['code'] as String,
    );
  }

  VerifyCode toDomain() {
    return VerifyCode(
      email: email,
      code: code,
    );
  }

}

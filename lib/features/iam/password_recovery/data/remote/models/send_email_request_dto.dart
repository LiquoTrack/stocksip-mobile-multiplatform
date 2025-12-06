import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';

class SendEmailRequestDto {
  final String email;

  const SendEmailRequestDto({required this.email});

  factory SendEmailRequestDto.fromJson(Map<String, dynamic> json) {
    return SendEmailRequestDto(email: json['email'] as String);
  }

  SendEmail toDomain() {
    return SendEmail(email: email);
  }
}
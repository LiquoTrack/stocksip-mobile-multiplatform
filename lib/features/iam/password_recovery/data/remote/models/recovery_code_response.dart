import 'package:stocksip/features/iam/password_recovery/domain/models/message.dart';

class RecoveryCodeResponse {
  final String message;

  RecoveryCodeResponse({required this.message});

  factory RecoveryCodeResponse.fromJson(dynamic json) {
    return RecoveryCodeResponse(message: json as String);
  }

  Message toDomain() {
    return Message(message: message);
  }
}

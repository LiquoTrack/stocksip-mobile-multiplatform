import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';

class AlertDto {
  final String id;
  final String title;
  final String message;
  final String severity;
  final String type;
  final String accountId;
  final String inventoryId;

  const AlertDto({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    required this.accountId,
    required this.inventoryId,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) {
    return AlertDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      type: json['type'] as String? ?? '',
      accountId: json['accountId'] as String? ?? '',
      inventoryId: json['inventoryId'] as String? ?? '',
    );
  }

  Alert toDomain() {
    return Alert(
      id: id,
      title: title,
      message: message,
      severity: severity,
      type: type,
      accountId: accountId,
      inventoryId: inventoryId,
    );
  }
}
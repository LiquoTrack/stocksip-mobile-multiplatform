import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';

/// Represents the state of alerts in the application.
class AlertsState {
  final List<Alert> alerts;

  final String message;
  final Status status;
  
  const AlertsState({
    this.alerts = const [],
    this.message = '',
    this.status = Status.initial,
  });

  AlertsState copyWith({
    List<Alert>? alerts,
    String? message,
    Status? status,
  }) {
    return AlertsState(
      alerts: alerts ?? this.alerts,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
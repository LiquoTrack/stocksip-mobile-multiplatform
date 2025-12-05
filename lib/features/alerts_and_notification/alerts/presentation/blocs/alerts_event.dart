import 'package:equatable/equatable.dart';
abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object> get props => [];
}

class LoadAlerts extends AlertsEvent {
  final String accountId;

  const LoadAlerts({required this.accountId});

  @override
  List<Object> get props => [accountId];
}
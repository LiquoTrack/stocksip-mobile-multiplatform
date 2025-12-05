import 'package:equatable/equatable.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';

abstract class AlertsState extends Equatable {
  const AlertsState();
  
  @override
  List<Object> get props => [];
}

class AlertsInitial extends AlertsState {}

class AlertsLoading extends AlertsState {}

class AlertsLoaded extends AlertsState {
  final List<Alert> alerts;

  const AlertsLoaded({required this.alerts});

  @override
  List<Object> get props => [alerts];
}

class AlertsError extends AlertsState {
  final String message;

  const AlertsError({required this.message});

  @override
  List<Object> get props => [message];
}
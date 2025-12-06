import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/repositories/alerts_repository.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_event.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final AlertsRepository repository; 

  AlertsBloc({required this.repository}) : super(AlertsState()) {
    on<LoadAlerts>(_onLoadAlerts);
  }

  Future<void> _onLoadAlerts(
    LoadAlerts event,
    Emitter<AlertsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Loading alerts...'));
    try {
      final alerts = await repository.getAlerts();
      emit(state.copyWith(status: Status.success, alerts: alerts, message: 'Alerts loaded successfully.'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/repositories/alerts_repository.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_event.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final AlertsRepository repository;

  AlertsBloc({required this.repository}) : super(AlertsInitial()) {
    on<LoadAlerts>(_onLoadAlerts);
  }

  Future<void> _onLoadAlerts(LoadAlerts event, Emitter<AlertsState> emit) async {
    emit(AlertsLoading());
    try {
      final alerts = await repository.getAlerts(accountId: event.accountId);
      emit(AlertsLoaded(alerts: alerts));
    } catch (e) {
      emit(AlertsError(message: e.toString()));
    }
  }
}

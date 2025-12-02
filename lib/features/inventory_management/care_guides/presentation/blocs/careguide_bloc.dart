import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/repositories/careguide_repository.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_state.dart';

class CareguideBloc extends Bloc<CareguideEvent, CareguideState> {
  final CareGuideRepository repository;

  CareguideBloc({required this.repository}) : super(CareguideState()) {
    on<GetCareGuidesByAccountIdEvent>(_onGetByAccountId);
    on<GetCareGuidesByProductTypeEvent>(_onGetByProductType);
  }

  FutureOr<void> _onGetByAccountId(
    GetCareGuidesByAccountIdEvent event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Fetching care guides...'));
    try {
      final guides = await repository.getAllCareGuideBytId(accountId: event.accountId);
      emit(state.copyWith(status: Status.success, guides: guides, message: 'Care guides fetched successfully.'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to fetch care guides: $e'));
    }
  }

  FutureOr<void> _onGetByProductType(
    GetCareGuidesByProductTypeEvent event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Fetching care guides...'));
    try {
      final guides = await repository.getCareGuideByProductType(accountId: event.accountId, productType: event.productType);
      emit(state.copyWith(status: Status.success, guides: guides, message: 'Care guides fetched successfully.'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to fetch care guides: $e'));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide_wrapper.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/repositories/careguide_repository.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_state.dart';

class CareguideBloc extends Bloc<CareguideEvent, CareguideState> {
  final CareGuideRepository repository;

  CareguideBloc({required this.repository}) : super(const CareguideState()) {
    on<GetCareGuidesByAccountIdEvent>(_onGetByAccountId);
    on<OnCareGuideCreated>(_onCreate);
    on<OnCareGuideUpdated>(_onUpdate);
    on<OnCareGuideDeleted>(_onDelete);
  }

  FutureOr<void> _onGetByAccountId(
    GetCareGuidesByAccountIdEvent event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Fetching care guides...'));
    try {
      final guides = await repository.getAllCareGuideById(accountId: event.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          wrapper: CareGuideWrapper(count: guides.length, careGuides: guides),
          message: '',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to fetch care guides: $e'));
    }
  }

  FutureOr<void> _onCreate(
    OnCareGuideCreated event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Creating care guide...'));
    try {
      final created = await repository.createCareGuide(careGuide: event.careGuide);
      final guides = await repository.getAllCareGuideById(accountId: created.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          wrapper: CareGuideWrapper(count: guides.length, careGuides: guides),
          message: 'Care guide created',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to create care guide: $e'));
    }
  }

  FutureOr<void> _onUpdate(
    OnCareGuideUpdated event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Updating care guide...'));
    try {
      final updated = await repository.updateCareGuide(careGuideId: event.careGuideId, careGuide: event.careGuide);
      final guides = await repository.getAllCareGuideById(accountId: updated.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          wrapper: CareGuideWrapper(count: guides.length, careGuides: guides),
          message: 'Care guide updated',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to update care guide: $e'));
    }
  }

  FutureOr<void> _onDelete(
    OnCareGuideDeleted event,
    Emitter<CareguideState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: 'Deleting care guide...'));
    try {
      await repository.deleteCareGuide(careGuideId: event.careGuideId);
      final guides = await repository.getAllCareGuideById(accountId: event.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          wrapper: CareGuideWrapper(count: guides.length, careGuides: guides),
          message: 'Care guide deleted',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: 'Failed to delete care guide: $e'));
    }
  }
}

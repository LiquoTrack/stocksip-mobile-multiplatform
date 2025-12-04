import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_state.dart';

/// Bloc responsible for managing the state of inventory details.
class InventoryDetailBloc
    extends Bloc<InventoryDetailEvent, InventoryDetailState> {
  final InventoryRepository inventoryRepository;

  /// Constructor for InventoryDetailBloc.
  InventoryDetailBloc({required this.inventoryRepository})
    : super(InventoryDetailState()) {
    on<LoadInventoryDetailEvent>(_onLoadInventoryDetail);
  }

  /// Handles the loading of inventory details.
  FutureOr<void> _onLoadInventoryDetail(
    LoadInventoryDetailEvent event,
    Emitter<InventoryDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));

    try {
      final inventoryDetail = await inventoryRepository.getInventoryById(
        inventoryId: event.inventoryId,
      );
      emit(
        state.copyWith(
          status: Status.success,
          selectedInventory: inventoryDetail,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}

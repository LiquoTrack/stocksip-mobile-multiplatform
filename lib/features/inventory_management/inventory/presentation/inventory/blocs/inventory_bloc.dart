import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_state.dart';

/// Bloc class for managing inventory-related events and states.
/// Handles events such as fetching inventories by warehouse ID
/// and updates the state accordingly.
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repository;

  InventoryBloc(this.repository) : super(const InventoryState()) {
    on<GetInventoriesByWarehouseIdEvent>(_getInventoriesByWarehouseId);
  }

  FutureOr<void> _getInventoriesByWarehouseId(
    GetInventoriesByWarehouseIdEvent event, 
    Emitter<InventoryState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      final List<InventoryResponse> inventories = await repository.getAllInventoriesByWarehouseId(warehouseId: event.warehouseId);
      emit(state.copyWith(status: Status.success, inventories: inventories));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_state.dart';

/// Bloc class for managing inventory-related events and states.
/// Handles events such as fetching inventories by warehouse ID
/// and updates the state accordingly.
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repository;

  /// Constructor for [InventoryBloc].
  InventoryBloc(this.repository) : super(const InventoryState()) {
    on<GetInventoriesByWarehouseIdEvent>(_getInventoriesByWarehouseId);
    on<DeleteInventoryEvent>(_deleteInventory);
  }

  /// Handles fetching inventories by a specific warehouse ID.
  FutureOr<void> _getInventoriesByWarehouseId(
    GetInventoriesByWarehouseIdEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final List<InventoryResponse> inventories = await repository
          .getAllInventoriesByWarehouseId(warehouseId: event.warehouseId);
      emit(state.copyWith(status: Status.success, inventories: inventories));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Handles the deletion of a specific inventory item.
  FutureOr<void> _deleteInventory(
    DeleteInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: Status.loading,
          message: 'Deleting inventory...',
        ),
      );

      final inventoryToValidate = await repository.getInventoryById(inventoryId: event.inventoryId);

      if (inventoryToValidate.currentStock > 0) {
        emit(
          state.copyWith(
            status: Status.failure,
            message: 'Cannot delete inventory with existing stock.',
          ),
        );
        return;
      }

      await repository.deleteInventoryById(inventoryId: event.inventoryId);
      final updatedInventories = state.inventories
          .where((inventory) => inventory.id != event.inventoryId)
          .toList();
      emit(
        state.copyWith(
          status: Status.success,
          inventories: updatedInventories,
          message: 'Inventory deleted successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to delete inventory: ${e.toString()}',
        ),
      );
    }
  }
}

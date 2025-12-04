import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_transfer_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/repositories/warehouse_repository.dart';

/// Bloc to manage inventory transfer events and states.
class InventoryTransferBloc
    extends Bloc<InventoryTransferEvent, InventoryTransferState> {
  final InventoryRepository inventoryRepository;
  final WarehouseRepository warehouseRepository;

  /// Constructor for [InventoryTransferBloc].
  InventoryTransferBloc({
    required this.inventoryRepository,
    required this.warehouseRepository,
  }) : super(const InventoryTransferState()) {
    on<LoadProductAndWarehouseListToTransferEvent>(
      _loadProductAndWarehouseList,
    );
    on<UpdateSelectedProductToTransferEvent>(_onUpdateSelectedProduct);
    on<UpdateSelectedWarehouseToTransferEvent>(_onUpdateSelectedWarehouse);
    on<UpdateQuantityToTransferEvent>(_onUpdateQuantityToTransfer);
    on<UpdateExpirationDateToTransferEvent>(_onUpdateExpirationDate);
    on<ExecuteInventoryTransferEvent>(_onExecuteInventoryTransfer);
    on<ClearTransferFormEvent>(_onClearTransferForm);
  }

  /// Load product list and warehouse list for a specific warehouse.
  FutureOr<void> _loadProductAndWarehouseList(
    LoadProductAndWarehouseListToTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      final inventories = await inventoryRepository
          .getAllInventoriesByWarehouseId(warehouseId: event.warehouseId);
      final warehouses = await warehouseRepository.fetchWarehouses();

      emit(
        state.copyWith(
          status: Status.success,
          inventories: inventories,
          warehouses: warehouses,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateSelectedProduct(
    UpdateSelectedProductToTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      emit(
        state.copyWith(
          status: Status.success,
          selectedProductId: event.productId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Update the selected warehouse for the inventory transfer.
  FutureOr<void> _onUpdateSelectedWarehouse(
    UpdateSelectedWarehouseToTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      emit(
        state.copyWith(
          status: Status.success,
          selectedWarehouseId: event.warehouseId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Update the quantity to transfer of the inventory item.
  FutureOr<void> _onUpdateQuantityToTransfer(
    UpdateQuantityToTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      emit(
        state.copyWith(
          status: Status.success,
          quantityToTransfer: event.quantityToTransfer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Update the expiration date of the inventory item.
  FutureOr<void> _onUpdateExpirationDate(
    UpdateExpirationDateToTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      emit(
        state.copyWith(
          status: Status.success,
          expirationDate: event.expirationDate,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Execute the inventory transfer.
  FutureOr<void> _onExecuteInventoryTransfer(
    ExecuteInventoryTransferEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    try {
      
      final request = InventoryTransferRequest(
        destinationWarehouseId: event.destinationWarehouseId,
        quantityToTransfer: event.quantityToTransfer,
      );

      await inventoryRepository.transferProductsToAnotherWarehousee(
        fromWarehouseId: event.sourceWarehouseId,
        productId: event.productId,
        request: request,
      );

      emit(
        state.copyWith(
          status: Status.success,
          message: 'Inventory transfer successful',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Clear the inventory transfer form.
  FutureOr<void> _onClearTransferForm(
    ClearTransferFormEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(state.copyWith(
      status: Status.initial,
      message: null,
      selectedProductId: '',
      selectedWarehouseId: '',
      quantityToTransfer: 0,
      expirationDate: null,
    ));
  }
}

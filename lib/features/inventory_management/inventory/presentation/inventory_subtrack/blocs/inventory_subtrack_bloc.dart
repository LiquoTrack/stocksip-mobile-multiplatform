import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_subtrack_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_state.dart';

/// Bloc class for managing inventory subtraction
/// Handles events and updates state accordingly
class InventorySubtrackBloc extends Bloc<InventorySubtrackEvent, InventorySubtrackState> {
  
  final InventoryRepository inventoryRepository;

  /// Constructor for [InventorySubtrackBloc]
  /// Takes [inventoryRepository] as a parameter
  InventorySubtrackBloc({required this.inventoryRepository}) : super(const InventorySubtrackState()) {
    on<LoadProductListToSubtrackEvent>(_loadProductsListToSubtrack);
    on<UpdateSelectedProductToSubtrackEvent>(_updateSelectedProductToSubtrack);
    on<UpdateQuantityToSubtrackEvent>(_updateQuantityToSubtrack);
    on<UpdateExpirationDateToSubtrackEvent>(_updateExpirationDateToSubtrack);
    on<SubmitInventorySubtrackEvent>(_submitInventorySubtrackForm);
    on<ClearSubtrackFormEvent>(_clearSubtrackForm);
  }

  /// Loads the list of products and inventories for the given warehouse
  FutureOr<void> _loadProductsListToSubtrack(
    LoadProductListToSubtrackEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      final inventories = await inventoryRepository.getAllInventoriesByWarehouseId(warehouseId: event.warehouseId);

      emit(state.copyWith(status: Status.success, inventories: inventories));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Updates the selected product to subtract
  FutureOr<void> _updateSelectedProductToSubtrack(
    UpdateSelectedProductToSubtrackEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      emit(state.copyWith(status: Status.success, selectedProductId: event.productId));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Updates the quantity to subtract
  FutureOr<void> _updateQuantityToSubtrack(
    UpdateQuantityToSubtrackEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      emit(state.copyWith(status: Status.success, quantityToSubtract: event.quantityToSubtrack));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Updates the expiration date to subtract
  FutureOr<void> _updateExpirationDateToSubtrack(
    UpdateExpirationDateToSubtrackEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      emit(state.copyWith(status: Status.success, expirationDate: event.expirationDate));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Submits the inventory subtrack form
  FutureOr<void> _submitInventorySubtrackForm(
    SubmitInventorySubtrackEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {

      final request = InventorySubtrackRequest(
        quantityToSubtrack: event.quantityToSubtrack, 
        subtrackReason: event.exitReason,
        expirationDate: event.expirationDate
      );

      await inventoryRepository.subtractProductsFromWarehouseInventory(
        warehouseId: event.warehouseId,
        productId: state.selectedProductId,
        request: request
      );

      emit(state.copyWith(status: Status.success));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Clears the subtrack form state
  FutureOr<void> _clearSubtrackForm(
    ClearSubtrackFormEvent event, 
    Emitter<InventorySubtrackState> emit
  ) async {

    emit(state.copyWith(
      status: Status.initial,
      selectedProductId: null,
      quantityToSubtract: 0,
      expirationDate: null
    ));
  }
}
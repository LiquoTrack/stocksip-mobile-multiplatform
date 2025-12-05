import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_addition_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_state.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';

/// Bloc class for managing inventory addition
/// Handles events and updates state accordingly
class InventoryAdditionBloc
    extends Bloc<InventoryAdditionEvent, InventoryAdditionState> {
  final InventoryRepository inventoryRepository;
  final ProductRepository productRepository;

  /// Constructor for [InventoryAdditionBloc]
  /// Takes [inventoryRepository] and [productRepository] as parameters
  InventoryAdditionBloc({
    required this.inventoryRepository,
    required this.productRepository,
  }) : super(const InventoryAdditionState()) {
    on<LoadProductListEvent>(_loadProductList);
    on<UpdateSelectedProductEvent>(_updateSelectedProduct);
    on<UpdateQuantityEvent>(_updateQuantity);
    on<UpdateExpirationDateEvent>(_updateExpirationDate);
    on<OnValidateStockToAddEvent>(_onValidateStockToAdd);
    on<SubmitInventoryAdditionEvent>(_submitInventoryAddition);
    on<ClearFormEvent>(_clearForm);
  }

  /// Loads the list of products and inventories for the given warehouse
  FutureOr<void> _loadProductList(
    LoadProductListEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final productsWithCount = await productRepository
          .getAllProductsByAccountId();
      final products = productsWithCount.products;

      final inventories = await inventoryRepository
          .getAllInventoriesByWarehouseId(warehouseId: event.warehouseId);

      emit(
        state.copyWith(
          status: Status.success,
          products: products,
          inventories: inventories,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Updates the selected product for the inventory addition
  FutureOr<void> _updateSelectedProduct(
    UpdateSelectedProductEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
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

  /// Updates the quantity to add for the inventory addition
  FutureOr<void> _updateQuantity(
    UpdateQuantityEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      emit(
        state.copyWith(status: Status.success, quantityToAdd: event.quantity),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Updates the expiration date for the inventory addition
  FutureOr<void> _updateExpirationDate(
    UpdateExpirationDateEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
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

  /// Submits the inventory addition request
  FutureOr<void> _submitInventoryAddition(
    SubmitInventoryAdditionEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final request = InventoryAdditionRequest(
        quantityToAdd: state.quantityToAdd,
        expirationDate: state.expirationDate,
      );

      await inventoryRepository.addProductsToWarehouseInventory(
        warehouseId: event.warehouseId,
        productId: state.selectedProductId,
        request: request,
      );

      emit(
        state.copyWith(
          status: Status.success,
          message: "Inventory added successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  /// Clears the form fields and resets the state
  FutureOr<void> _clearForm(
    ClearFormEvent event,
    Emitter<InventoryAdditionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.initial,
        message: null,
        selectedProductId: '',
        quantityToAdd: 0,
        expirationDate: null,
      ),
    );
  }

  FutureOr<void> _onValidateStockToAdd(
    event,
    Emitter<InventoryAdditionState> emit,
  ) {
    final stockToAdd = event.stockToAdd;
    final quantity = int.tryParse(stockToAdd) ?? 0;

    if (quantity <= 0) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Quantity must be greater than zero',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: Status.success,
          quantityToAdd: quantity,
          message: '',
        ),
      );
    }
  }
}

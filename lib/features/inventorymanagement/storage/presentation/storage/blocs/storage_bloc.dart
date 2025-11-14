import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventorymanagement/storage/data/services/remote/product_service.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_response.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/products_with_count.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_state.dart';

/// Bloc to manage storage-related events and states in the inventory management feature.
/// Handles fetching products by account ID and updating the state accordingly.
/// Uses the [ProductService] to interact with the data layer.
/// Extends [Bloc] with [StorageEvent] and [StorageState].
class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final ProductService service;

  StorageBloc({required this.service}) : super(StorageState()) {
    on<GetProductsByAccountIdEvent>(_getProductsByAccountId);
  }

  FutureOr<void> _getProductsByAccountId(
    GetProductsByAccountIdEvent event, 
    Emitter<StorageState> emit
  ) async {
    // Here you would typically get the account ID from a token manager service.
    final String accountId = "6914c9de8a3e6c966a0cb82d";

    if (accountId.isEmpty) {
      // Handle the case where account ID is not available.
      return;
    }

    // Emit loading state
    emit(state.copyWith(
      status: Status.loading, 
      message: "Fetching products..."
    ));

    try {
      /// Fetch products by account ID using the service.
      final ProductsWithCount productResponse = await service.getProductsByAccountId(accountId: accountId);

      /// Extract products from the response.
      final List<ProductResponse> products = productResponse.products;

      // Emit success state with fetched products
      emit(state.copyWith(
        status: Status.success, 
        products: products,
        message: "Products fetched successfully."
      ));

    } catch (e) {
      // Emit error state in case of failure
      emit(state.copyWith(
        status: Status.failure, 
        message: "Failed to fetch products: $e"
      ));
      return;
    }
  }
}
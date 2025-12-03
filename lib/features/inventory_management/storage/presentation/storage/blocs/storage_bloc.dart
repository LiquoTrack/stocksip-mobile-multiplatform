import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';

/// Bloc to manage storage-related events and states in the inventory management feature.
/// Handles fetching products by account ID and updating the state accordingly.
/// Uses the [ProductService] to interact with the data layer.
/// Extends [Bloc] with [StorageEvent] and [StorageState].
class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final ProductRepository repository;

  StorageBloc({required this.repository}) : super(StorageState()) {
    on<GetProductsByAccountIdEvent>(_getProductsByAccountId);
  }

  FutureOr<void> _getProductsByAccountId(
    GetProductsByAccountIdEvent event, 
    Emitter<StorageState> emit
  ) async {
    // Emit loading state
    emit(state.copyWith(
      status: Status.loading, 
      message: "Fetching products..."
    ));

    try {
      /// Fetch products by account ID using the service.
      final ProductsWithCount productResponse = await repository.getAllProductsByAccountId();

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
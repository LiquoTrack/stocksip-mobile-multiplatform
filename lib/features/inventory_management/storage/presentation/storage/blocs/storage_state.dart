import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';

/// Represents the state of the storage feature in the inventory management system.
/// Includes the current status, a list of products with their counts, and an optional message.
/// Used in state management to track and update the storage state.
class StorageState {
  final Status status;
  final String? message;
  final ProductsWithCount products;
  final ProductResponse? selectedProduct;

  /// Creates a new instance of [StorageState].
  /// [status] indicates the current status of the storage feature.
  /// [products] is a list of products in storage.
  /// [message] is an optional field for any relevant messages.
  const StorageState({
    this.status = Status.initial,
    this.products = const ProductsWithCount(
      products: [],
      totalCount: 0,
      maxTotalAllowed: 0,
    ),
    this.message,
    this.selectedProduct,
  });

  /// Creates a copy of the current [StorageState] with optional new values.
  /// This allows for immutability while updating specific fields.
  StorageState copyWith({
    Status? status,
    ProductsWithCount? products,
    String? message,
    ProductResponse? selectedProduct,
  }) {
    return StorageState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}

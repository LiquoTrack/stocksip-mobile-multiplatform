import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_response.dart';

/// Represents the state of the storage feature in the inventory management system.
/// Includes the current status, a list of products with their counts, and an optional message.
/// Used in state management to track and update the storage state.
class StorageState {
  final Status status;
  final List<ProductResponse> products;
  final String? message;

  /// Creates a new instance of [StorageState].
  /// [status] indicates the current status of the storage feature.
  /// [products] is a list of products in storage.
  /// [message] is an optional field for any relevant messages.
  const StorageState({
    this.status = Status.initial,
    this.products = const [],
    this.message,
  });

  /// Creates a copy of the current [StorageState] with optional new values.
  /// This allows for immutability while updating specific fields.
  StorageState copyWith({
    Status? status,
    List<ProductResponse>? products,
    String? message,
  }) {
    return StorageState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }
}
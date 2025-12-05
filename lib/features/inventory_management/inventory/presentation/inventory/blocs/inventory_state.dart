import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';

/// Represents the state of the inventory management feature.
class InventoryState {
  final Status status;
  final String message;
  final List<InventoryResponse> inventories;

  /// Creates an instance of [InventoryState].
  const InventoryState({
    this.status = Status.initial,
    this.message = '',
    this.inventories = const [],
  });

  /// Creates a copy of the current state with optional new values.
  InventoryState copyWith({
    Status? status,
    String? message,
    List<InventoryResponse>? inventories,
  }) {
    return InventoryState(
      status: status ?? this.status,
      message: message ?? this.message,
      inventories: inventories ?? this.inventories,
    );
  }
}
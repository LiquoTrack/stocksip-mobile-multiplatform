import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';

/// State class for managing inventory details
class InventoryDetailState {
  final Status status;
  final String? message;

  final InventoryResponse? selectedInventory;

  /// Constructor for [InventoryDetailState]
  const InventoryDetailState({
    this.status = Status.initial,
    this.message,
    this.selectedInventory,
  });

  /// Creates a copy of the current state with optional new values.
  InventoryDetailState copyWith({
    Status? status,
    String? message,
    InventoryResponse? selectedInventory,
  }) {
    return InventoryDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      selectedInventory: selectedInventory ?? this.selectedInventory,
    );
  }
}
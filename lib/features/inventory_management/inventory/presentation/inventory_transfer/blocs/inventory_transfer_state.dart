import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

/// State class for managing inventory transfer
/// Includes status, messages, warehouses, inventories, current quantity, selected product, quantity to transfer, and expiration date
class InventoryTransferState {
  final Status status;
  final String? message;

  final List<Warehouse> warehouses;
  final List<InventoryResponse> inventories;

  final String currentQuantity;

  final String selectedProductId;
  final String selectedWarehouseId;
  final String selectedInventoryId;
  final int quantityToTransfer;
  final DateTime? expirationDate;

  /// Constructor for [InventoryTransferState]
  const InventoryTransferState({
    this.status = Status.initial,
    this.message,
    this.warehouses = const [],
    this.inventories = const [],
    this.currentQuantity = '',
    this.selectedProductId = '',
    this.selectedInventoryId = '',
    this.selectedWarehouseId = '',
    this.quantityToTransfer = 0,
    this.expirationDate,
  });

  /// Creates a copy of the current state with optional new values
  /// Returns a new instance of [InventoryTransferState] with updated fields
  InventoryTransferState copyWith({
    Status? status,
    String? message,
    List<Warehouse>? warehouses,
    List<InventoryResponse>? inventories,
    String? currentQuantity,
    String? selectedProductId,
    String? selectedInventoryId,
    String? selectedWarehouseId,
    int? quantityToTransfer,
    DateTime? expirationDate,
  }) {
    return InventoryTransferState(
      status: status ?? this.status,
      message: message ?? this.message,
      warehouses: warehouses ?? this.warehouses,
      inventories: inventories ?? this.inventories,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      selectedWarehouseId: selectedWarehouseId ?? this.selectedWarehouseId,
      selectedInventoryId: selectedInventoryId ?? this.selectedInventoryId,
      quantityToTransfer: quantityToTransfer ?? this.quantityToTransfer,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}
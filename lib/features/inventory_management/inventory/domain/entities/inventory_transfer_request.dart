/// Represents a request to transfer inventory items to another warehouse.
/// Includes details such as destination warehouse ID, quantity to transfer,
/// and optional expiration date for perishable items.
class InventoryTransferRequest {
  final String destinationWarehouseId;
  final int quantityToTransfer;
  final DateTime? expirationDate;

  /// Creates an [InventoryTransferRequest] instance.
  InventoryTransferRequest({
    required this.destinationWarehouseId,
    required this.quantityToTransfer,
    this.expirationDate,
  });
}
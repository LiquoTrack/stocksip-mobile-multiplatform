/// Base class for all inventory transfer events.
abstract class InventoryTransferEvent {
  const InventoryTransferEvent();
}

/// Event to load the product list and warehouse list for a specific warehouse.
class LoadProductAndWarehouseListToTransferEvent extends InventoryTransferEvent {
  final String warehouseId;
  
  const LoadProductAndWarehouseListToTransferEvent(this.warehouseId);
}

/// Event to update the selected product for the inventory item.
class UpdateSelectedProductToTransferEvent extends InventoryTransferEvent {
  final String? productId;
  final String? inventoryId;

  const UpdateSelectedProductToTransferEvent(this.productId, this.inventoryId);
}

/// Event to update the selected warehouse for the inventory transfer.
class UpdateSelectedWarehouseToTransferEvent extends InventoryTransferEvent {
  final String? warehouseId;

  const UpdateSelectedWarehouseToTransferEvent(this.warehouseId);
}

/// Event to update the quantity to transfer of the inventory item.
class UpdateQuantityToTransferEvent extends InventoryTransferEvent {
  final int quantityToTransfer;

  const UpdateQuantityToTransferEvent(this.quantityToTransfer);
}

/// Event to update the expiration date of the inventory item.
class UpdateExpirationDateToTransferEvent extends InventoryTransferEvent {
  final DateTime? expirationDate;

  const UpdateExpirationDateToTransferEvent(this.expirationDate);
}

/// Event to execute the inventory transfer.
class ExecuteInventoryTransferEvent extends InventoryTransferEvent {
  final String sourceWarehouseId;
  final String destinationWarehouseId;
  final String productId;
  final int quantityToTransfer;
  final DateTime? expirationDate;

  const ExecuteInventoryTransferEvent({
    required this.sourceWarehouseId,
    required this.destinationWarehouseId,
    required this.productId,
    required this.quantityToTransfer,
    this.expirationDate,
  });
}

/// Event to clear the inventory transfer form.
class ClearTransferFormEvent extends InventoryTransferEvent {
  const ClearTransferFormEvent();
}
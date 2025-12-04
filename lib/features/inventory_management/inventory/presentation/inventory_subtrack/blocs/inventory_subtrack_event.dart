/// Base class for all inventory subtrack events.
abstract class InventorySubtrackEvent {
  const InventorySubtrackEvent();
}

/// Event to load the product list for a specific warehouse.
class LoadProductListToSubtrackEvent extends InventorySubtrackEvent {
  final String warehouseId;
  
  const LoadProductListToSubtrackEvent(this.warehouseId);
}

/// Event to update the selected product for the inventory item.
class UpdateSelectedProductToSubtrackEvent extends InventorySubtrackEvent {
  final String? productId;

  const UpdateSelectedProductToSubtrackEvent(this.productId);
}

/// Event to update the quantity to subtract of the inventory item.
class UpdateQuantityToSubtrackEvent extends InventorySubtrackEvent {
  final int quantityToSubtrack;

  const UpdateQuantityToSubtrackEvent(this.quantityToSubtrack);
}

/// Event to update the expiration date of the inventory item.
class UpdateExpirationDateToSubtrackEvent extends InventorySubtrackEvent {
  final DateTime? expirationDate;

  const UpdateExpirationDateToSubtrackEvent(this.expirationDate);
}

/// Event to submit the inventory subtrack form.
class SubmitInventorySubtrackEvent extends InventorySubtrackEvent {
  final String warehouseId;
  final String productId;
  final int quantityToSubtrack;
  final DateTime? expirationDate;
  final String exitReason;

  const SubmitInventorySubtrackEvent({
    required this.warehouseId,
    required this.productId,
    required this.quantityToSubtrack,
    this.expirationDate,
    required this.exitReason,
  });
}

/// Event to clear the inventory subtrack form.
class ClearSubtrackFormEvent extends InventorySubtrackEvent {
  const ClearSubtrackFormEvent();
}
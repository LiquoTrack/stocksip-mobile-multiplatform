/// Base class for all inventory addition events.
abstract class InventoryAdditionEvent {
  const InventoryAdditionEvent();
}

/// Event to load the product list for a specific warehouse.
class LoadProductListEvent extends InventoryAdditionEvent {
  final String warehouseId;

  const LoadProductListEvent(this.warehouseId);
}

/// Event to update the selected product for the inventory item.
class UpdateSelectedProductEvent extends InventoryAdditionEvent {
  final String? productId;

  const UpdateSelectedProductEvent(this.productId);
}

/// Event to update the quantity of the inventory item.
class UpdateQuantityEvent extends InventoryAdditionEvent {
  final int quantity;

  const UpdateQuantityEvent(this.quantity);
}

/// Event to update the expiration date of the inventory item.
class UpdateExpirationDateEvent extends InventoryAdditionEvent {
  final DateTime? expirationDate;

  const UpdateExpirationDateEvent(this.expirationDate);
}

/// Event to submit the inventory addition form.
class SubmitInventoryAdditionEvent extends InventoryAdditionEvent {
  final String warehouseId;
  final String productId;
  final int quantity;
  final DateTime? expirationDate;

  const SubmitInventoryAdditionEvent({
    required this.warehouseId,
    required this.productId,
    required this.quantity,
    this.expirationDate,
  });
}

/// Event to clear the inventory addition form.
class ClearFormEvent extends InventoryAdditionEvent {
  const ClearFormEvent();
}
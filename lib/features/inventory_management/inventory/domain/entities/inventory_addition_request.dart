/// Represents a request to add items to the inventory.
/// Contains details about the quantity to add and an optional expiration date.
class InventoryAdditionRequest {
  final int quantityToAdd;
  final DateTime? expirationDate;

  /// Constructs an [InventoryAdditionRequest] instance with the given parameters.
  const InventoryAdditionRequest({
    required this.quantityToAdd,
    this.expirationDate,
  });
}
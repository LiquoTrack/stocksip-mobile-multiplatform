/// Represents a request to subtrack items from inventory.
/// Includes the quantity to subtrack, the reason for subtracking, and an optional expiration date.
class InventorySubtrackRequest {
  final int quantityToSubtrack;
  final String subtrackReason;
  final DateTime? expirationDate;

  /// Creates an [InventorySubtrackRequest] with the given parameters.
  InventorySubtrackRequest({
    required this.quantityToSubtrack,
    required this.subtrackReason,
    this.expirationDate,
  });
}
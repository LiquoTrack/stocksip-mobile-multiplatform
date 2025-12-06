/// Represents the response structure for inventory items in the inventory management system.
/// Contains detailed information about each inventory item.
class InventoryResponse {
  final String id;
  final String productId;
  final String productName;
  final String productType;
  final String productBrand;
  final double unitPrice;
  final String currencyCode;
  final int minimumStock;
  final String imageUrl;
  final String currentState;
  final int currentStock;
  final String warehouseId;
  final DateTime? expirationDate;

  /// Constructor for creating an [InventoryResponse] instance.
  const InventoryResponse({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.productBrand,
    required this.unitPrice,
    required this.currencyCode,
    required this.minimumStock,
    required this.imageUrl,
    required this.currentState,
    required this.currentStock,
    required this.warehouseId,
    this.expirationDate,
  });
}
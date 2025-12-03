/// Represents the response structure for inventory items in the inventory management system.
/// Contains detailed information about each inventory item.
class InventoryResponse {
  final String id;
  final String productId;
  final String productName;
  final String productType;
  final String productBrand;
  final String unitPrice;
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

  /// Creates an [InventoryResponse] instance from a JSON map.
  factory InventoryResponse.fromJson(Map<String, dynamic> json) {
    return InventoryResponse(
      id: json['inventoryId'] as String,
      productId: json['productId'] as String,
      productName: json['name'] as String,
      productType: json['type'] as String,
      productBrand: json['brand'] as String,
      unitPrice: json['unitPrice'] as String,
      currencyCode: json['moneyCode'] as String,
      minimumStock: json['minimumStock'] as int,
      imageUrl: json['imageUrl'] as String,
      currentState: json['currentState'] as String,
      currentStock: json['quantity'] as int,
      warehouseId: json['warehouseId'] as String,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'] as String)
          : null,
    );
  }
}
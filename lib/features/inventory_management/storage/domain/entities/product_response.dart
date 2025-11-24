/// Represents a product response in the inventory management system.
/// Contains details about the product.
/// Includes a factory constructor to create an instance from JSON data.
class ProductResponse {
  final String id;
  final String name;
  final String type;
  final String brand;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final int totalStockInStore;
  final double content;
  final String imageUrl;
  final String? supplierId;
  final bool isInWarehouse;

  // Constructor for creating a ProductResponse instance.
  const ProductResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.totalStockInStore,
    required this.content,
    required this.imageUrl,
    this.supplierId,
    required this.isInWarehouse,
  });

  /// Creates a [ProductResponse] instance from a JSON map.
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      code: json['code'] as String,
      minimumStock: json['minimumStock'] as int,
      totalStockInStore: json['totalStockInStore'] as int,
      content: (json['content'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      supplierId: json['supplierId'] as String?,
      isInWarehouse: json['isInWarehouse'] as bool,
    );
  }
}
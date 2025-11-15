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
  final String? supplierId = "string";
  final String isInWarehouse;

  /// Constructs a ProductResponse instance with the given parameters.
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
    required this.isInWarehouse,
  });

  /// Creates a ProductResponse instance from a JSON map.
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      brand: json['brand'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      code: json['code'],
      minimumStock: json['minimumStock'],
      totalStockInStore: json['totalStockInStore'],
      content: (json['content'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      isInWarehouse: json['isInWarehouse'],
    );
  }
}
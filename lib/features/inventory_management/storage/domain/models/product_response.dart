/// Represents a product response in the inventory management system.
/// Contains details about the product.
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

  /// Constructor for creating a [ProductResponse] instance.
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
}
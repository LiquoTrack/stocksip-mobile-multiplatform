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

  /// Creates a copy of this [ProductResponse] with the given fields replaced
  ProductResponse copyWith({
    String? id,
    String? name,
    String? type,
    String? brand,
    double? unitPrice,
    String? code,
    int? minimumStock,
    int? totalStockInStore,
    double? content,
    String? imageUrl,
    String? supplierId,
    bool? isInWarehouse,
  }) {
    return ProductResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      unitPrice: unitPrice ?? this.unitPrice,
      code: code ?? this.code,
      minimumStock: minimumStock ?? this.minimumStock,
      totalStockInStore: totalStockInStore ?? this.totalStockInStore,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      supplierId: supplierId ?? this.supplierId,
      isInWarehouse: isInWarehouse ?? this.isInWarehouse,
    );
  }
}
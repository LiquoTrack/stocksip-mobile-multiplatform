import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// Represents a product response in the inventory management system.
/// Contains details about the product.
class ProductResponseDto {
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

  /// Constructor for [ProductResponseDto].
  const ProductResponseDto({
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

  /// Creates an instance of [ProductResponseDto] from a JSON map.
  factory ProductResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductResponseDto(
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

  /// Converts the [ProductResponseDto] instance to a domain entity [ProductResponse].
  ProductResponse toDomain() {
    return ProductResponse(
      id: id,
      name: name,
      type: type,
      brand: brand,
      unitPrice: unitPrice,
      code: code,
      minimumStock: minimumStock,
      totalStockInStore: totalStockInStore,
      content: content,
      imageUrl: imageUrl,
      supplierId: supplierId,
      isInWarehouse: isInWarehouse,
    );
  }
}
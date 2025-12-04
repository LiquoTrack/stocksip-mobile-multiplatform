import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';

/// Data Transfer Object for Inventory, used for JSON serialization and deserialization.
class InventoryResponseDto {
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

  /// Constructor for [InventoryResponseDto].
  const InventoryResponseDto({
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

  /// Creates an instance of [InventoryResponseDto] from a JSON map.
  factory InventoryResponseDto.fromJson(Map<String, dynamic> json) {
    return InventoryResponseDto(
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

  /// Converts the [InventoryResponseDto] instance to a domain entity [InventoryResponse].
  InventoryResponse toDomain() {
    return InventoryResponse(
      id: id,
      productId: productId,
      productName: productName,
      productType: productType,
      productBrand: productBrand,
      unitPrice: unitPrice,
      currencyCode: currencyCode,
      minimumStock: minimumStock,
      imageUrl: imageUrl,
      currentState: currentState,
      currentStock: currentStock,
      warehouseId: warehouseId,
      expirationDate: expirationDate,
    );
  }
}
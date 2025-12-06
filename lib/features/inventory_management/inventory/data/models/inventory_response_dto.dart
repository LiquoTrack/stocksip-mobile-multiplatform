import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';

/// Data Transfer Object for Inventory, used for JSON serialization and deserialization.
class InventoryResponseDto {
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
      id: json['inventoryId'],
      productId: json['productId'],
      productName: json['name'],
      productType: json['type'],
      productBrand: json['brand'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      currencyCode: json['moneyCode'],
      minimumStock: json['minimumStock'],
      imageUrl: json['imageUrl'],
      currentState: json['currentState'],
      currentStock: json['quantity'],
      warehouseId: json['warehouseId'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
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
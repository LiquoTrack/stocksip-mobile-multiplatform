import 'dart:io';

/// Represents a request to create or update a product in the inventory system.
/// Contains necessary details about the product.
/// Includes an image file for the product.
class ProductRequest {
  final String name;
  final String type;
  final String brand;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File? image;
  final String? supplierId = "string";

  /// Constructs a ProductRequest instance with the given parameters.
  const ProductRequest({
    required this.name,
    required this.type,
    required this.brand,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    this.image,
  });

  ProductRequest copyWith({
    String? name,
    String? type,
    String? brand,
    double? unitPrice,
    String? code,
    int? minimumStock,
    double? content,
    File? image,
  }) {
    return ProductRequest(
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      unitPrice: unitPrice ?? this.unitPrice,
      code: code ?? this.code,
      minimumStock: minimumStock ?? this.minimumStock,
      content: content ?? this.content,
      image: image ?? this.image,
    );
  }
}
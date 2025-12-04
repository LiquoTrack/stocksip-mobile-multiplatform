import 'dart:io';

/// Represents a request to update a product in the inventory system.
/// Contains updatable details about the product.
/// Includes an image file for the product.
class ProductUpdateRequest {
  final String name;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File? image;

  /// Constructs a ProductUpdateRequest instance with the given parameters.
  const ProductUpdateRequest({
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    this.image,
  });

  ProductUpdateRequest copyWith({
    String? name,
    double? unitPrice,
    String? code,
    int? minimumStock,
    double? content,
    File? image,
  }) {
    return ProductUpdateRequest(
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      code: code ?? this.code,
      minimumStock: minimumStock ?? this.minimumStock,
      content: content ?? this.content,
      image: image ?? this.image,
    );
  }
}
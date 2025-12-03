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
  final File image;
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
    required this.image,
  });
}
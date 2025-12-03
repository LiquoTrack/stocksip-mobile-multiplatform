import 'dart:io';

/// Data Transfer Object for updating a product in the inventory system.
class ProductUpdateRequestDto {
  final String name;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File? imageFile;

  /// Constructs a [ProductUpdateRequestDto] instance with the given parameters.
  const ProductUpdateRequestDto({
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    this.imageFile,
  });
}
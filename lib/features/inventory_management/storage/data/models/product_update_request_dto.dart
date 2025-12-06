import 'dart:io';

import 'package:stocksip/features/inventory_management/storage/domain/models/product_update_request.dart';

/// Data Transfer Object for updating a product in the inventory system.
class ProductUpdateRequestDto {
  final String name;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final File? imageFile;

  /// Constructs a [ProductUpdateRequestDto] instance with the given parameters.
  const ProductUpdateRequestDto({
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    this.imageFile,
  });

  /// Converts a domain model [ProductUpdateRequest] to a [ProductUpdateRequestDto].
  factory ProductUpdateRequestDto.fromDomain(ProductUpdateRequest request) {
    return ProductUpdateRequestDto(
      name: request.name,
      unitPrice: request.unitPrice,
      code: request.code,
      minimumStock: request.minimumStock,
      imageFile: request.image,
    );
  }
}
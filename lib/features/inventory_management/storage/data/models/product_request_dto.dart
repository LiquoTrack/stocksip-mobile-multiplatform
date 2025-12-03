import 'dart:io';

import 'package:stocksip/features/inventory_management/storage/domain/models/product_request.dart';

/// Data Transfer Object for [ProductRequest].
class ProductRequestDto {
  final String name;
  final String type;
  final String brand;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File? imageFile;
  final String? supplierId = "string";

  /// Constructs a [ProductRequestDto] instance with the given parameters.
  const ProductRequestDto({
    required this.name,
    required this.type,
    required this.brand,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    this.imageFile,
  });

  /// Converts a [ProductRequest] domain model to a [ProductRequestDto].
  factory ProductRequestDto.fromDomain(ProductRequest request) {
    return ProductRequestDto(
      name: request.name,
      type: request.type,
      brand: request.brand,
      unitPrice: request.unitPrice,
      code: request.code,
      minimumStock: request.minimumStock,
      content: request.content,
      imageFile: request.image,
    );
  }
}
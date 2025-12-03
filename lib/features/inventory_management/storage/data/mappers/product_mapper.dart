import 'dart:io';

import 'package:stocksip/features/inventory_management/storage/data/models/product_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_request.dart';

/// Mapper class for converting [ProductRequest] to [ProductRequestDto].
class ProductMapper {

  /// Converts a [ProductRequest] to a [ProductRequestDto].
  static ProductRequestDto toRequestDto(
    ProductRequest product, {
      File? imageFile  
  }) {
    return ProductRequestDto(
      name: product.name,
      type: product.type,
      brand: product.brand,
      unitPrice: product.unitPrice,
      code: product.code,
      minimumStock: product.minimumStock,
      content: product.content,
      image: imageFile,
    );
  }
}
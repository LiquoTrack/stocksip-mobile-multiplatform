import 'dart:io';

import 'package:stocksip/features/inventory_management/storage/data/models/product_update_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_update_request.dart';

/// Mapper class to convert between [ProductUpdateRequest] and [ProductUpdateRequestDto].
class ProductUpdateMapper {

  /// Converts a [ProductUpdateRequest] to a [ProductUpdateRequestDto].
  static ProductUpdateRequestDto toRequestDto(
    ProductUpdateRequest product, {
      File? imageFile  
  }) {
    return ProductUpdateRequestDto(
      name: product.name,
      unitPrice: product.unitPrice,
      code: product.code,
      minimumStock: product.minimumStock,
      imageFile: imageFile,
    );
  }
}
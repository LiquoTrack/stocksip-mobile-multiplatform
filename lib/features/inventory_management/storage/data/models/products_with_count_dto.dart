import 'package:stocksip/features/inventory_management/storage/data/models/product_response_dto.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';

/// Data Transfer Object (DTO) for [ProductsWithCount].
class ProductsWithCountDto {
  final List<ProductResponseDto> products;
  final int totalCount;
  final int maxTotalAllowed;

  /// Constructs a [ProductsWithCountDto] instance with the given parameters.
  const ProductsWithCountDto({
    required this.products,
    required this.totalCount,
    required this.maxTotalAllowed,
  });

  /// Creates a [ProductsWithCountDto] instance from a JSON map.
  factory ProductsWithCountDto.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List;
    List<ProductResponseDto> productsList = productsJson
        .map((productJson) => ProductResponseDto.fromJson(productJson))
        .toList();

    return ProductsWithCountDto(
      products: productsList,
      totalCount: json['totalCount'],
      maxTotalAllowed: json['maxTotalAllowed'],
    );
  }

  /// Converts this DTO to its corresponding domain entity.
  ProductsWithCount toDomain() {
    return ProductsWithCount(
      products: products.map((dto) => dto.toDomain()).toList(),
      totalCount: totalCount,
      maxTotalAllowed: maxTotalAllowed,
    );
  }
}
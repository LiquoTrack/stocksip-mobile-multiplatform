import 'package:stocksip/features/inventory_management/storage/domain/models/product_type.dart';

/// Data Transfer Object for [ProductType].
class ProductTypeDto {
  final String name;

  /// Constructor for [ProductTypeDto].
  const ProductTypeDto({required this.name});

  /// Creates an instance of [ProductTypeDto] from a JSON map.
  factory ProductTypeDto.fromJson(Map<String, dynamic> json) {
    return ProductTypeDto(name: json['name']);
  }

  /// Converts the [ProductTypeDto] instance to a domain entity [ProductType].
  ProductType toDomain() {
    return ProductType(name: name);
  }
}
import 'package:stocksip/features/inventory_management/storage/domain/models/brand.dart';

/// Data Transfer Object for [Brand].
class BrandDto {
  final String name;

  /// Constructs a [BrandDto] instance with the given name.
  BrandDto({required this.name});

  /// Creates an instance of [BrandDto] from a JSON map.
  factory BrandDto.fromJson(Map<String, dynamic> json) {
    return BrandDto(name: json['name']);
  }

  /// Converts the [BrandDto] instance to a domain entity [Brand].
  Brand toDomain() {
    return Brand(name: name);
  }
}
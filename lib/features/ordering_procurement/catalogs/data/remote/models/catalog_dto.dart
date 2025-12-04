import 'catalog_item_dto.dart';

class CatalogDto {
  final String id;
  final String name;
  final String description;
  final List<CatalogItemDto> catalogItems;
  final String ownerAccount;
  final String contactEmail;
  final bool isPublished;
  final String? warehouseId;

  CatalogDto({
    required this.id,
    required this.name,
    required this.description,
    required this.catalogItems,
    required this.ownerAccount,
    required this.contactEmail,
    required this.isPublished,
    this.warehouseId,
  });

  factory CatalogDto.fromJson(Map<String, dynamic> json) {
    return CatalogDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      catalogItems: (json['catalogItems'] as List<dynamic>?)
              ?.map((item) => CatalogItemDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      ownerAccount: json['ownerAccount'] as String,
      contactEmail: json['contactEmail'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
      warehouseId: json['warehouseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'catalogItems': catalogItems.map((item) => item.toJson()).toList(),
      'ownerAccount': ownerAccount,
      'contactEmail': contactEmail,
      'isPublished': isPublished,
      'warehouseId': warehouseId,
    };
  }
}

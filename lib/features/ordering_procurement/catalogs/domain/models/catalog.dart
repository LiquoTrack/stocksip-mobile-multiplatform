class Catalog {
  final String id;
  final String name;
  final String description;
  final String contactEmail;
  final bool isPublished;
  final List<CatalogItem> catalogItems;
  final String ownerAccount;
  final String? warehouseId;

  Catalog({
    required this.id,
    required this.name,
    required this.description,
    required this.contactEmail,
    required this.isPublished,
    required this.catalogItems,
    required this.ownerAccount,
    this.warehouseId,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      contactEmail: json['contactEmail'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
      catalogItems: (json['catalogItems'] as List<dynamic>?)
          ?.map((item) => CatalogItem.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      ownerAccount: json['ownerAccount'] as String? ?? json['ownerAccountId'] as String? ?? '',
      warehouseId: json['warehouseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'contactEmail': contactEmail,
      'isPublished': isPublished,
      'catalogItems': catalogItems.map((item) => item.toJson()).toList(),
      'ownerAccount': ownerAccount,
      'warehouseId': warehouseId,
    };
  }

  Catalog copyWith({
    String? id,
    String? name,
    String? description,
    String? contactEmail,
    bool? isPublished,
    List<CatalogItem>? catalogItems,
    String? ownerAccount,
    String? warehouseId,
  }) {
    return Catalog(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      contactEmail: contactEmail ?? this.contactEmail,
      isPublished: isPublished ?? this.isPublished,
      catalogItems: catalogItems ?? this.catalogItems,
      ownerAccount: ownerAccount ?? this.ownerAccount,
      warehouseId: warehouseId ?? this.warehouseId,
    );
  }
}

class CatalogItem {
  final String productId;
  final String productName;
  final double? amount;
  final String? currency;
  final DateTime? addedDate;
  final int availableStock;
  final String? imageUrl; // "productImage" en el DTO

  CatalogItem({
    required this.productId,
    required this.productName,
    this.amount,
    this.currency,
    this.addedDate,
    required this.availableStock,
    this.imageUrl,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      addedDate: json['addedDate'] != null
          ? DateTime.tryParse(json['addedDate'] as String)
          : null,
      availableStock: json['availableStock'] as int? ?? 0,
      imageUrl: json['productImage'] as String? ?? json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'amount': amount,
      'currency': currency,
      'addedDate': addedDate?.toIso8601String(),
      'availableStock': availableStock,
      'productImage': imageUrl,
    };
  }
}
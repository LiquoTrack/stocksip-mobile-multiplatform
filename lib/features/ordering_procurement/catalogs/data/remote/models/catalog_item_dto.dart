class CatalogItemDto {
  final String productId;
  final double? amount;
  final String? currency;
  final DateTime? addedDate;
  final String productName;
  final String? imageUrl; // Maps from 'productImage' in JSON
  final int? availableStock;

  CatalogItemDto({
    required this.productId,
    this.amount,
    this.currency,
    this.addedDate,
    required this.productName,
    this.imageUrl,
    this.availableStock,
  });

  factory CatalogItemDto.fromJson(Map<String, dynamic> json) {
    return CatalogItemDto(
      productId: json['productId'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      addedDate: json['addedDate'] != null 
          ? DateTime.tryParse(json['addedDate'] as String)
          : null,
      productName: json['productName'] as String,
      imageUrl: json['productImage'] as String?,
      availableStock: json['availableStock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'amount': amount,
      'currency': currency,
      'addedDate': addedDate?.toIso8601String(),
      'productName': productName,
      'productImage': imageUrl,
      'availableStock': availableStock,
    };
  }
}

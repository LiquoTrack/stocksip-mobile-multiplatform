class AddCatalogItemRequest {
  final String productId;
  final String warehouseId;
  final int stock;

  AddCatalogItemRequest({
    required this.productId,
    required this.warehouseId,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'warehouseId': warehouseId,
      'stock': stock,
    };
  }
}

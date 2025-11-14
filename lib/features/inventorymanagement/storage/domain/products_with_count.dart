import 'package:stocksip/features/inventorymanagement/storage/domain/product_response.dart';

/// Represents a collection of products along with their count information
/// in the inventory management system.
/// Includes a factory constructor to create an instance from JSON data.
class ProductsWithCount {
  final List<ProductResponse> products;
  final int totalCount;
  final int maxTotalAllowed;

  /// Constructs a ProductsWithCount instance with the given parameters.
  ProductsWithCount({
    required this.products,
    required this.totalCount,
    required this.maxTotalAllowed,
  });

  /// Creates a ProductsWithCount instance from a JSON map.
  factory ProductsWithCount.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List;
    List<ProductResponse> productsList = productsJson
        .map((productJson) => ProductResponse.fromJson(productJson))
        .toList();

    return ProductsWithCount(
      products: productsList,
      totalCount: json['totalCount'],
      maxTotalAllowed: json['maxTotalAllowed'],
    );
  }
}
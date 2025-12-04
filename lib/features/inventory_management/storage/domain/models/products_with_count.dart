import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// Represents a collection of products along with their count information
/// in the inventory management system.
class ProductsWithCount {
  final List<ProductResponse> products;
  final int totalCount;
  final int maxTotalAllowed;

  /// Constructs a [ProductsWithCount] instance with the given parameters.
  const ProductsWithCount({
    required this.products,
    required this.totalCount,
    required this.maxTotalAllowed,
  });

  /// Creates a copy of this [ProductsWithCount] with the given fields replaced
  /// by new values.
  ProductsWithCount copyWith({
    List<ProductResponse>? products,
    int? totalCount,
    int? maxTotalAllowed,
  }) {
    return ProductsWithCount(
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      maxTotalAllowed: maxTotalAllowed ?? this.maxTotalAllowed,
    );
  }
}
import 'package:stocksip/features/inventory_management/storage/domain/models/product_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_update_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';

/// Abstract repository interface for managing products in the inventory management system.
/// Defines methods for fetching, registering, updating, and deleting products.
abstract class ProductRepository {
  
  /// Fetches all products associated with the given [accountId].
  /// Returns a [ProductsWithCount] instance containing the products and their count information.
  Future<ProductsWithCount> getAllProductsByAccountId();

  /// Fetches a product by its [productId].
  /// Returns a [ProductResponse] instance representing the product details.
  Future<ProductResponse> getProductById({required String productId});

  /// Registers a new product for the given [accountId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the newly created product.
  Future<ProductResponse> registerProduct({required ProductRequest request});

  /// Updates an existing product identified by [productId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the updated product.
  Future<ProductResponse> updateProduct({required String productId, required ProductUpdateRequest request});

  /// Deletes a product identified by [productId].
  /// Returns a [Future] that completes when the deletion is done.
  Future<void> deleteProduct({required String productId});
}
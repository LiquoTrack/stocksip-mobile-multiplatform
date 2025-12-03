import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/product_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/product_update_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/products_with_count.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';

/// Implementation of the ProductRepository interface for managing products
/// in the inventory management system. This class interacts with the
/// ProductService to perform CRUD operations on products.
class ProductRepositoryImpl implements ProductRepository {

  // The service used to perform remote operations related to products.
  final ProductService service;

  // Constructor that accepts a ProductService instance.
  const ProductRepositoryImpl({required this.service});
  
  /// Deletes a product identified by [productId].
  /// Returns a [Future] that completes when the deletion is done.
  @override
  Future<void> deleteProduct({required String productId}) {
    return service.deleteProductById(productId: productId);
  }
  
  /// Fetches all products associated with the given [accountId].
  /// Returns a [ProductsWithCount] instance containing the products and their count information.
  @override
  Future<ProductsWithCount> getAllProductsByAccountId({required String accountId}) {
    return service.getProductsByAccountId(accountId: accountId);
  }
  
  /// Fetches a product by its [productId].
  /// Returns a [ProductResponse] instance representing the product details.
  @override
  Future<ProductResponse> getProductById({required String productId}) {
    return service.getProductById(productId: productId);
  }
  
  /// Registers a new product for the given [accountId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the newly created product.
  @override
  Future<ProductResponse> registerProduct({required String accountId, required ProductRequest request}) {
    return service.registerProduct(accountId: accountId, request: request);
  }
  
  /// Updates an existing product identified by [productId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the updated product.
  @override
  Future<ProductResponse> updateProduct({required String productId, required ProductUpdateRequest request}) {
    return service.updateProduct(productId: productId, request: request);
  }
}
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/data/models/product_update_request_dto.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_update_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';

/// Implementation of the [ProductRepository] interface for managing products
/// in the inventory management system. This class interacts with the
/// ProductService to perform CRUD operations on products.
class ProductRepositoryImpl implements ProductRepository {
  final ProductService service;
  final TokenStorage tokenStorage;

  /// Constructor that accepts a [ProductService] and the [TokenStorage] instance.
  const ProductRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  /// Deletes a product identified by [productId].
  /// Returns a [Future] that completes when the deletion is done.
  @override
  Future<void> deleteProduct({required String productId}) async {
    try {
      return await service.deleteProductById(productId: productId);
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches all products associated with the given [accountId] taken from the [TokenStorage].
  /// Returns a [ProductsWithCount] instance containing the products and their count information.
  @override
  Future<ProductsWithCount> getAllProductsByAccountId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');

      final productsWithCountDto = await service.getProductsByAccountId(
        accountId: accountId,
      );
      return productsWithCountDto.toDomain();
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches products by warehouse ID.
  /// Returns a list of [ProductResponse] instances for the warehouse inventory.
  @override
  Future<List<ProductResponse>> getProductsByWarehouseId({required String warehouseId}) async {
    try {
      final productDtos = await service.getProductsByWarehouseId(
        warehouseId: warehouseId,
      );
      return productDtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches a product by its [productId].
  /// Returns a [ProductResponse] instance representing the product details.
  @override
  Future<ProductResponse> getProductById({required String productId}) async {
    try {
      final product = await service.getProductById(productId: productId);
      return product.toDomain();
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Registers a new product for the given [accountId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the newly created product.
  @override
  Future<ProductResponse> registerProduct({
    required ProductRequest request,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');

      final requestDto = ProductRequestDto.fromDomain(request);
      final product = await service.registerProduct(
        accountId: accountId,
        dto: requestDto,
      );
      return product.toDomain();
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Updates an existing product identified by [productId] using the provided [request] data.
  /// Returns a [ProductResponse] instance representing the updated product.
  @override
  Future<ProductResponse> updateProduct({
    required String productId,
    required ProductUpdateRequest request,
  }) async {
    try {
      final requestDto = ProductUpdateRequestDto.fromDomain(request);
      final product = await service.updateProduct(
        productId: productId,
        dto: requestDto,
      );
      return product.toDomain();
    } catch (e) {
      return Future.error('$e');
    }
  }
}

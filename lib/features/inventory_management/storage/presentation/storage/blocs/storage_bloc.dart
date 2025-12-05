import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_update_request.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/products_with_count.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/brand_repository.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_type_repository.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';

/// Bloc to manage storage-related events and states in the inventory management feature.
/// Handles fetching products by account ID and updating the state accordingly.
/// Uses the [ProductService] to interact with the data layer.
/// Extends [Bloc] with [StorageEvent] and [StorageState].
class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final ProductRepository repository;
  final ProductTypeRepository productTypeRepository;
  final BrandRepository brandRepository;

  StorageBloc({
    required this.repository,
    required this.productTypeRepository,
    required this.brandRepository,
  }) : super(StorageState()) {
    on<GetAllProductsEvent>(_getProductsByAccountId);
    on<GetProductsByWarehouseIdEvent>(_getProductsByWarehouseId);
    on<GetAllBrandNamesEvent>(_getAllBrandNames);
    on<GetAllProductTypeNamesEvent>(_getAllProductTypeNames);
    on<OnProductNameChanged>(_onProductNameChanged);
    on<OnProductTypeChanged>(_onProductTypeChanged);
    on<OnProductBrandChanged>(_onProductBrandChanged);
    on<OnProductUnitPriceChanged>(_onProductUnitPriceChanged);
    on<OnCurrencyCodeChanged>(_onCurrencyCodeChanged);
    on<OnProductMinimumStockChanged>(_onProductMinimumStockChanged);
    on<OnProductContentChanged>(_onProductContentChanged);
    on<OnValidateMinimumStock>(_onValidateMinimumStock);
    on<OnProductDeletedEvent>(_deleteProductById);
    on<OnProductCreatedEvent>(_onProductCreated);
    on<OnProductUpdatedEvent>(_onProductUpdated);
  }

  /// Handles fetching products by account ID.
  FutureOr<void> _getProductsByAccountId(
    GetAllProductsEvent event,
    Emitter<StorageState> emit,
  ) async {
    // Emit loading state
    emit(
      state.copyWith(status: Status.loading, message: "Fetching products..."),
    );

    try {
      /// Fetch products by account ID using the service.
      final ProductsWithCount productResponse = await repository
          .getAllProductsByAccountId();

      final products = state.products.copyWith(
        products: productResponse.products,
        totalCount: productResponse.totalCount,
        maxTotalAllowed: productResponse.maxTotalAllowed,
      );

      // Emit success state with fetched products
      emit(
        state.copyWith(
          status: Status.success,
          products: products,
          message: "Products fetched successfully.",
        ),
      );
    } catch (e) {
      // Emit error state in case of failure
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to fetch products: $e",
        ),
      );
      return;
    }
  }

  /// Handles fetching products by warehouse ID.
  FutureOr<void> _getProductsByWarehouseId(
    GetProductsByWarehouseIdEvent event,
    Emitter<StorageState> emit,
  ) async {
    // Emit loading state
    emit(
      state.copyWith(
        status: Status.loading,
        message: "Fetching warehouse products...",
      ),
    );

    try {
      /// Fetch products by warehouse ID using the repository.
      final products = await repository.getProductsByWarehouseId(
        warehouseId: event.warehouseId,
      );

      final productsWithCount = state.products.copyWith(
        products: products,
        totalCount: products.length,
        maxTotalAllowed: state.products.maxTotalAllowed,
      );

      // Emit success state with fetched products
      emit(
        state.copyWith(
          status: Status.success,
          products: productsWithCount,
          message: "Warehouse products fetched successfully.",
        ),
      );
    } catch (e) {
      // Emit error state in case of failure
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to fetch warehouse products: $e",
        ),
      );
      return;
    }
  }

  /// Handles the deletion of a product by its ID.
  FutureOr<void> _deleteProductById(
    OnProductDeletedEvent event,
    Emitter<StorageState> emit,
  ) async {
    // Emit loading state
    emit(
      state.copyWith(status: Status.loading, message: "Deleting product..."),
    );

    try {
      if (event.productId.isEmpty) {
        throw Exception('Invalid product ID');
      }

      final productToValidate = await repository.getProductById(
        productId: event.productId,
      );

      if (productToValidate.totalStockInStore > 0) {
        throw Exception('Cannot delete product with existing stock in store');
      }

      await repository.deleteProduct(productId: event.productId);

      final updateProducts = state.products.products
          .where((p) => p.id != event.productId)
          .toList();

      final productsWithCount = state.products.copyWith(
        products: updateProducts,
        totalCount: updateProducts.length,
        maxTotalAllowed: state.products.maxTotalAllowed,
      );

      emit(
        state.copyWith(
          status: Status.success,
          products: productsWithCount,
          message: "Product deleted successfully.",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to delete product: $e",
        ),
      );
      return;
    }
  }

  /// Handles changes to the product name.
  FutureOr<void> _onProductNameChanged(
    OnProductNameChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(name: event.name),
      ),
    );
  }

  /// Handles changes to the product type.
  FutureOr<void> _onProductTypeChanged(
    OnProductTypeChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(type: event.type),
      ),
    );
  }

  /// Handles changes to the product brand.
  FutureOr<void> _onProductBrandChanged(
    OnProductBrandChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(brand: event.brand),
      ),
    );
  }

  /// Handles changes to the product unit price.
  FutureOr<void> _onProductUnitPriceChanged(
    OnProductUnitPriceChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(
          unitPrice: event.unitPrice,
        ),
      ),
    );
  }

  /// Handles changes to the currency code of the product.
  FutureOr<void> _onCurrencyCodeChanged(
    OnCurrencyCodeChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(
          code: event.currencyCode,
        ),
      ),
    );
  }

  /// Handles changes to the product minimum stock.
  FutureOr<void> _onProductMinimumStockChanged(
    OnProductMinimumStockChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(
          minimumStock: event.minimumStock,
        ),
      ),
    );
  }

  /// Handles changes to the product content.
  FutureOr<void> _onProductContentChanged(
    OnProductContentChanged event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: state.selectedProduct?.copyWith(
          content: event.content,
        ),
      ),
    );
  }

  /// Validates the minimum stock value.
  FutureOr<void> _onValidateMinimumStock(
    OnValidateMinimumStock event,
    Emitter<StorageState> emit,
  ) {
    if (event.minimumStock < 0) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Minimum stock cannot be negative',
        ),
      );
    } else {
      emit(state.copyWith(status: Status.success, message: null));
    }
  }

  /// Handles the creation of a new product.
  FutureOr<void> _onProductCreated(
    OnProductCreatedEvent event,
    Emitter<StorageState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: Status.loading, message: "Creating product..."),
      );

      final request = ProductRequest(
        name: event.product.name,
        type: event.product.type,
        brand: event.product.brand,
        unitPrice: event.product.unitPrice,
        code: event.product.code,
        minimumStock: event.product.minimumStock,
        content: event.product.content,
        image: event.imageFile,
      );

      final productToCreate = await repository.registerProduct(
        request: request,
      );

      final updatedList = List.of(state.products.products)
        ..add(productToCreate);

      final wrapper = state.products.copyWith(
        products: updatedList,
        totalCount: updatedList.length,
        maxTotalAllowed: state.products.maxTotalAllowed,
      );

      emit(
        state.copyWith(
          status: Status.success,
          products: wrapper,
          message: "Product created successfully.",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to create product: $e",
        ),
      );
      return;
    }
  }

  /// Handles the update of an existing product.
  FutureOr<void> _onProductUpdated(
    OnProductUpdatedEvent event,
    Emitter<StorageState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: Status.loading, message: "Updating product..."),
      );

      final request = ProductUpdateRequest(
        name: event.product.name,
        unitPrice: event.product.unitPrice,
        code: event.product.code,
        minimumStock: event.product.minimumStock,
        content: event.product.content,
        image: event.imageFile,
      );

      await repository.updateProduct(
        productId: event.product.id,
        request: request,
      );

      final products = await repository.getAllProductsByAccountId();

      final wrapper = state.products.copyWith(
        products: products.products,
        totalCount: products.totalCount,
        maxTotalAllowed: products.maxTotalAllowed,
      );

      emit(
        state.copyWith(
          status: Status.success,
          products: wrapper,
          message: "Product updated successfully.",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to update product: $e",
        ),
      );
      return;
    }
  }

  /// Handles fetching all brand names.
  FutureOr<void> _getAllBrandNames(
    GetAllBrandNamesEvent event,
    Emitter<StorageState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: Status.loading,
          message: "Fetching brand names...",
        ),
      );

      final brandNames = await brandRepository.getAllBrandNames();

      emit(
        state.copyWith(
          status: Status.success,
          brandNames: brandNames,
          message: "Brand names fetched successfully.",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to fetch brand names: $e",
        ),
      );
      return;
    }
  }

  /// Handles fetching all product type names.
  FutureOr<void> _getAllProductTypeNames(
    GetAllProductTypeNamesEvent event,
    Emitter<StorageState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: Status.loading,
          message: "Fetching product type names...",
        ),
      );

      final productTypeNames = await productTypeRepository
          .getAllProductTypeNames();

      emit(
        state.copyWith(
          status: Status.success,
          productTypeNames: productTypeNames,
          message: "Product type names fetched successfully.",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to fetch product type names: $e",
        ),
      );
      return;
    }
  }
}

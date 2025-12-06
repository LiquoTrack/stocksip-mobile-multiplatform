import 'dart:io';

import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// Represents events related to storage operations in the inventory management feature.
abstract class StorageEvent {
  const StorageEvent();
}

/// Event to handle changes in product name.
class OnProductNameChanged extends StorageEvent {
  final String name;

  const OnProductNameChanged({required this.name});
}

/// Event to handle changes in product type.
class OnProductTypeChanged extends StorageEvent {
  final String type;

  const OnProductTypeChanged({required this.type});
}

/// Event to handle changes in product brand.
class OnProductBrandChanged extends StorageEvent {
  final String brand;

  const OnProductBrandChanged({required this.brand});
}

/// Event to handle changes in product unit price.
class OnProductUnitPriceChanged extends StorageEvent {
  final double unitPrice;

  const OnProductUnitPriceChanged({required this.unitPrice});
}

/// Event to handle changes in product currency code.
class OnCurrencyCodeChanged extends StorageEvent {
  final String currencyCode;

  const OnCurrencyCodeChanged({required this.currencyCode});
}

/// Event to handle changes in product minimum stock.
class OnProductMinimumStockChanged extends StorageEvent {
  final int minimumStock;

  const OnProductMinimumStockChanged({required this.minimumStock});
}

/// Event to handle changes in product content.
class OnProductContentChanged extends StorageEvent {
  final double content;

  const OnProductContentChanged({required this.content});
}

/// Event to create a new product.
class OnProductCreatedEvent extends StorageEvent {
  final ProductResponse product;
  final File? imageFile;

  const OnProductCreatedEvent({required this.product, this.imageFile});
}

/// Event to update an existing product.
class OnProductUpdatedEvent extends StorageEvent {
  final ProductResponse product;
  final File? imageFile;

  const OnProductUpdatedEvent({required this.product, this.imageFile});
}

/// Event to delete a product by its unique identifier.
class OnProductDeletedEvent extends StorageEvent {
  final String productId;

  const OnProductDeletedEvent(this.productId);
}

/// Event to fetch products by a specific account ID.
/// Requires the account ID as a parameter.
/// The account ID is taken from the tokenManager service.
class GetAllProductsEvent extends StorageEvent {

  const GetAllProductsEvent();
}

/// Event to fetch all brand names available in the storage system.
class GetAllBrandNamesEvent extends StorageEvent {

  const GetAllBrandNamesEvent();
}

/// Event to fetch all product type names available in the storage system.
class GetAllProductTypeNamesEvent extends StorageEvent {

  const GetAllProductTypeNamesEvent();
}

/// Event to fetch products by a specific warehouse ID.
/// Used to load products from a warehouse's inventory.
class GetProductsByWarehouseIdEvent extends StorageEvent {
  final String warehouseId;

  const GetProductsByWarehouseIdEvent({required this.warehouseId});
}

/// Event to validate the minimum stock of a product.
class OnValidateMinimumStock extends StorageEvent {
  final int minimumStock;

  const OnValidateMinimumStock({required this.minimumStock});
}
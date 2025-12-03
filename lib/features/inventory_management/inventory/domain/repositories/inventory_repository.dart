import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_addition_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_subtrack_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_transfer_request.dart';

/// Abstract repository interface for managing inventories in the inventory management system.
/// Defines methods for fetching, adding, subtracting, transferring, and deleting inventories.
abstract class InventoryRepository {

  /// Fetches all inventories associated with the given [warehouseId].
  /// Returns a list of [InventoryResponse] instances representing the inventories.
  /// Or an empty list if no inventories are found.
  Future<List<InventoryResponse>> getAllInventoriesByWarehouseId({required String warehouseId});

  /// Fetches inventory by [productId] and [warehouseId].
  /// Returns an [InventoryResponse] instance representing the inventory details.
  /// Or throws an error if no inventory is found.
  Future<InventoryResponse> getInventoryByProductIdAndWarehouseId({required String productId, required String warehouseId});

  /// Adds products to the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated or created inventory.
  Future<InventoryResponse> addProductsToWarehouseInventory({required String warehouseId, required String productId, required InventoryAdditionRequest request});

  /// Subtracts products from the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated inventory.
  Future<InventoryResponse> subtractProductsFromWarehouseInventory({required String warehouseId, required String productId, required InventorySubtrackRequest request});

  /// Transfers products from one warehouse to another identified by [fromWarehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated origin inventory.
  Future<InventoryResponse> transferProductsToAnotherWarehousee({required String fromWarehouseId, required String productId, required InventoryTransferRequest request});

  /// Fetches inventory by its unique [inventoryId].
  /// Returns an [InventoryResponse] instance representing the inventory details.
  /// Or throws an error if no inventory is found.
  Future<InventoryResponse> getInventoryById({required String inventoryId});

  /// Deletes inventory identified by [inventoryId].
  /// Returns a [Future] that completes when the deletion is done.
  Future<void> deleteInventoryById({required String inventoryId});
}
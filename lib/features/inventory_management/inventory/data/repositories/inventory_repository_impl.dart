import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_addition_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_subtrack_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/models/inventory_transfer_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventory/data/remote/inventory_service.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_addition_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_subtrack_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_transfer_request.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/repositories/inventory_repository.dart';

/// Implementation of the [InventoryRepository] interface for managing inventories.
/// This class provides concrete implementations for the methods defined in the repository interface.
class InventoryRepositoryImpl implements InventoryRepository {
  
  final InventoryService service;
  
  /// Constructor for creating an [InventoryRepositoryImpl] instance.
  const InventoryRepositoryImpl({required this.service});

  /// Adds products to the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated or created inventory.
  @override
  Future<InventoryResponse> addProductsToWarehouseInventory({required String warehouseId, required String productId, required InventoryAdditionRequest request}) async {
    try {

      final requestDto = InventoryAdditionRequestDto.fromDomain(request);
      return service.addProductsToWarehouseInventory(warehouseId: warehouseId, productId: productId, request: requestDto)
        .then((dto) => dto.toDomain());
      
    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Deletes inventory identified by [inventoryId].
  /// Returns a [Future] that completes when the deletion is done.
  @override
  Future<void> deleteInventoryById({required String inventoryId}) async {
    try {

      await service.deleteInventoryById(inventoryId: inventoryId);

    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches all inventories associated with the given [warehouseId].
  /// Returns a list of [InventoryResponse] instances representing the inventories.
  /// Or an empty list if no inventories are found.
  @override
  Future<List<InventoryResponse>> getAllInventoriesByWarehouseId({required String warehouseId}) async {
    try {

      final dtos = await service.getAllInventoriesByWarehouseId(warehouseId: warehouseId);
      return dtos.map((dto) => dto.toDomain()).toList();

    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches inventory by its unique [inventoryId].
  /// Returns an [InventoryResponse] instance representing the inventory details.
  /// Or throws an error if no inventory is found.
  @override
  Future<InventoryResponse> getInventoryById({required String inventoryId}) async {
    try {

      return await service.getInventoryById(inventoryId: inventoryId)
        .then((dto) => dto.toDomain());

    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Fetches inventory by [productId] and [warehouseId].
  /// Returns an [InventoryResponse] instance representing the inventory details.
  /// Or throws an error if no inventory is found.
  @override
  Future<InventoryResponse> getInventoryByProductIdAndWarehouseId({required String productId, required String warehouseId}) async {
    try {

      return await service.getInventoryByProductIdAndWarehouseId(productId: productId, warehouseId: warehouseId)
        .then((dto) => dto.toDomain());

    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Subtracts products from the warehouse inventory identified by [warehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated inventory.
  @override
  Future<InventoryResponse> subtractProductsFromWarehouseInventory({required String warehouseId, required String productId, required InventorySubtrackRequest request}) async {
    try {

      final requestDto = InventorySubtrackRequestDto.fromDomain(request);
      return await service.subtractProductsFromWarehouseInventory(warehouseId: warehouseId, productId: productId, request: requestDto)
        .then((dto) => dto.toDomain());

    } catch (e) {
      return Future.error('$e');
    }
  }

  /// Transfers products from one warehouse to another identified by [fromWarehouseId] and [productId]
  /// using the provided [request] data.
  /// Returns an [InventoryResponse] instance representing the updated origin inventory.
  @override
  Future<InventoryResponse> transferProductsToAnotherWarehousee({required String fromWarehouseId, required String productId, required InventoryTransferRequest request}) async {
    try {

      final requestDto = InventoryTransferRequestDto.fromDomain(request);
      return await service.transferProductsToAnotherWarehousee(fromWarehouseId: fromWarehouseId, productId: productId, request: requestDto)
        .then((dto) => dto.toDomain());

    } catch (e) {
      return Future.error('$e');
    }
  }
}
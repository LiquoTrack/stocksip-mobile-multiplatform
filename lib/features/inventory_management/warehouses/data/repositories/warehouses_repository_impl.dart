import 'dart:io';

import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/mappers/warehouse_mapper.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_wrapper_dto.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/services/warehouse_service.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/repositories/warehouse_repository.dart';

class WarehousesRepositoryImpl extends WarehouseRepository {
  final WarehouseService service;
  final TokenStorage tokenStorage;

  WarehousesRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<void> addWarehouse(Warehouse warehouseData, File? imageFile) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');
      final warehouseRequest = WarehouseMapper.toRequestDto(
        warehouseData,
        imageFile: imageFile,
      );

      await service.registerWarehouse(accountId, warehouseRequest);
    } catch (e) {
      throw Exception('Error adding warehouse: $e');
    }
  }

  @override
  Future<void> deleteWarehouse(String warehouseId) async {
    try {
      await service.deleteWarehouse(warehouseId);
    } catch (e) {
      throw Exception('Error deleting warehouse: $e');
    }
  }

  @override
  Future<List<Warehouse>> fetchWarehouses() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');

      final WarehouseWrapperDto wrapper = await service
          .getWarehousesByAccountId(accountId);

      return wrapper.warehouses.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error fetching warehouses: $e');
    }
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouseData) async {
    try {
      await service.updateWarehouse(
        warehouseData.warehouseId,
        WarehouseMapper.toRequestDto(warehouseData),
      );
    } catch (e) {
      throw Exception('Error updating warehouse: $e');
    }
  }
}

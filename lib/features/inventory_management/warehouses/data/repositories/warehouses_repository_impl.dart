import 'dart:io';

import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/mappers/warehouse_mapper.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/services/warehouse_service.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse_wrapper.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/repositories/warehouse_repository.dart';

class WarehousesRepositoryImpl extends WarehouseRepository {
  final WarehouseService service;
  final TokenStorage tokenStorage;

  WarehousesRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<Warehouse> addWarehouse(Warehouse warehouseData, File? imageFile) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');
      final warehouseRequest = WarehouseMapper.toRequestDto(
        warehouseData,
        imageFile: imageFile,
      );
      final dto = await service.registerWarehouse(accountId, warehouseRequest);
      return dto.toDomain();
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
  Future<WarehouseWrapper> fetchWarehouses() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');

      final wrapperDto = await service
          .getWarehousesByAccountId(accountId);

      return wrapperDto.toDomain();
    } catch (e) {
      throw Exception('Error fetching warehouses: $e');
    }
  }

  @override
  Future<Warehouse> updateWarehouse(Warehouse warehouseData) async {
    try {
      final dto = await service.updateWarehouse(
        warehouseData.warehouseId,
        WarehouseMapper.toRequestDto(warehouseData),
      );
      return dto.toDomain();
    } catch (e) {
      throw Exception('Error updating warehouse: $e');
    }
  }
}
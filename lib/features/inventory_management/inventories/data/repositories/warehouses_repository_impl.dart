import 'dart:io';

import 'package:stocksip/features/inventory_management/inventories/data/remote/mappers/warehouse_mapper.dart';
import 'package:stocksip/features/inventory_management/inventories/data/remote/models/warehouse_wrapper_dto.dart';
import 'package:stocksip/features/inventory_management/inventories/data/remote/services/warehouse_service.dart';
import 'package:stocksip/features/inventory_management/inventories/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/inventories/domain/repositories/warehouse_repository.dart';

class WarehousesRepositoryImpl extends WarehouseRepository {
  final WarehouseService service;

  WarehousesRepositoryImpl({required this.service});

  @override
  Future<void> addWarehouse(
    String accountId,
    Warehouse warehouseData,
    File? imageFile,
  ) async {
    try {
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
  Future<List<Warehouse>> fetchWarehouses(String accountId) async {
    try {
      final WarehouseWrapperDto wrapper = await service
          .getWarehousesByAccountId(accountId);

      return wrapper.warehouses
          .map((dto) => dto.toDomain())
          .toList();
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

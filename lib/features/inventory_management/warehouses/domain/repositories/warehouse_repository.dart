import 'dart:io';

import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

abstract class WarehouseRepository {

  Future<void> addWarehouse(Warehouse warehouseData, File? imageFile);

  Future<List<Warehouse>> fetchWarehouses();

  Future<void> updateWarehouse(Warehouse warehouseData);

  Future<void> deleteWarehouse(String warehouseId);
}
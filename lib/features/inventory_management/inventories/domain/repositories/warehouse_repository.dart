import 'dart:io';

import 'package:stocksip/features/inventory_management/inventories/domain/models/warehouse.dart';

abstract class WarehouseRepository {

  Future<void> addWarehouse(String accountId, Warehouse warehouseData, File? imageFile);

  Future<List<Warehouse>> fetchWarehouses(String accountId);

  Future<void> updateWarehouse(Warehouse warehouseData);

  Future<void> deleteWarehouse(String warehouseId);
}
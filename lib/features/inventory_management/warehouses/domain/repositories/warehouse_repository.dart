import 'dart:io';

import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

abstract class WarehouseRepository {

  Future<Warehouse> addWarehouse(Warehouse warehouseData, File? imageFile) ;

  Future<List<Warehouse>> fetchWarehouses();

  Future<Warehouse> updateWarehouse(Warehouse warehouseData);

  Future<void> deleteWarehouse(String warehouseId);
}
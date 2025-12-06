import 'dart:io';

import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse_wrapper.dart';

abstract class WarehouseRepository {

  Future<Warehouse> addWarehouse(Warehouse warehouseData, File? imageFile) ;

  Future<WarehouseWrapper> fetchWarehouses();

  Future<Warehouse> updateWarehouse(Warehouse warehouseData);

  Future<void> deleteWarehouse(String warehouseId);
}
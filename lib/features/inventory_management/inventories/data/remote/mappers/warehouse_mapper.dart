import 'dart:io';

import 'package:stocksip/features/inventory_management/inventories/data/remote/models/warehouse_request_dto.dart';
import 'package:stocksip/features/inventory_management/inventories/domain/models/warehouse.dart';

class WarehouseMapper {
  static WarehouseRequestDto toRequestDto(
    Warehouse warehouse, {
    File? imageFile,
  }) {
    return WarehouseRequestDto(
      name: warehouse.name,
      addressStreet: warehouse.addressStreet,
      addressCity: warehouse.addressCity,
      addressDistrict: warehouse.addressDistrict,
      addressPostalCode: warehouse.addressPostalCode,
      addressCountry: warehouse.addressCountry,
      temperatureMin: warehouse.temperatureMin.toDouble(),
      temperatureMax: warehouse.temperatureMax.toDouble(),
      capacity: warehouse.capacity.toDouble(),
      imageFile: imageFile,
    );
  }
}
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_dto.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse_wrapper.dart';

class WarehouseWrapperDto {
  List<WarehouseDto> warehouses;
  int total;
  int maxWarehousesAllowed;

  WarehouseWrapperDto({
    required this.warehouses,
    required this.total,
    required this.maxWarehousesAllowed,
  });

  factory WarehouseWrapperDto.fromJson(Map<String, dynamic> json) {
    var list = json['warehouses'] as List? ?? [];
    List<WarehouseDto> warehousesList = list
        .map((i) => WarehouseDto.fromJson(i))
        .toList();

    return WarehouseWrapperDto(
      warehouses: warehousesList,
      total: json['total'] as int? ?? 0,
      maxWarehousesAllowed: json['maxWarehousesAllowed'] as int? ?? 0,
    );
  }

  WarehouseWrapper toDomain() {
    return WarehouseWrapper(
      warehouses: warehouses.map((dto) => dto.toDomain()).toList(),
      total: total,
      maxWarehousesAllowed: maxWarehousesAllowed,
    );
  }
}

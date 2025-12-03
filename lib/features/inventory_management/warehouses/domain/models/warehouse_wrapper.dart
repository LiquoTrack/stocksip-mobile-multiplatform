import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

class WarehouseWrapper {
  final List<Warehouse> warehouses;
  final int total;
  final int maxWarehousesAllowed;

  const WarehouseWrapper({
    required this.warehouses,
    required this.total,
    required this.maxWarehousesAllowed,
  });

  WarehouseWrapper copyWith({
    List<Warehouse>? warehouses,
    int? total,
    int? maxWarehousesAllowed,
  }) {
    return WarehouseWrapper(
      warehouses: warehouses ?? this.warehouses,
      total: total ?? this.total,
      maxWarehousesAllowed: maxWarehousesAllowed ?? this.maxWarehousesAllowed,
    );
  }
}

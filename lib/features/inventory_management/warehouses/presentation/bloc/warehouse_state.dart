import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse_wrapper.dart';

class WarehouseState {
  final Status status;
  final WarehouseWrapper warehouseWrapper;
  final String messsage;
  final Warehouse? selectedWarehouse;

  const WarehouseState({
    this.status = Status.initial,
    this.warehouseWrapper = const WarehouseWrapper(
      warehouses: [],
      total: 0,
      maxWarehousesAllowed: 0,
    ),
    this.messsage = "",
    this.selectedWarehouse,
  });

  WarehouseState copyWith({
    Status? status,
    WarehouseWrapper? warehouseWrapper,
    String? messsage,
    Warehouse? selectedWarehouse,
  }) {
    return WarehouseState(
      status: status ?? this.status,
      warehouseWrapper: warehouseWrapper ?? this.warehouseWrapper,
      messsage: messsage ?? this.messsage,
      selectedWarehouse: selectedWarehouse ?? this.selectedWarehouse,
    );
  }
}
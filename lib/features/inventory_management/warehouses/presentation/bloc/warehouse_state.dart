import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse_wrapper.dart';

class WarehouseState {
  final Status status;
  final WarehouseWrapper warehouseWrapper;
  final String? messsage;

  const WarehouseState({
    this.status = Status.initial,
    this.warehouseWrapper = const WarehouseWrapper(
      warehouses: [],
      total: 0,
      maxWarehousesAllowed: 0,
    ),
    this.messsage,
  });

  WarehouseState copyWith({
    Status? status,
    WarehouseWrapper? warehouseWrapper,
    String? messsage,
  }) {
    return WarehouseState(
      status: status ?? this.status,
      warehouseWrapper: warehouseWrapper ?? this.warehouseWrapper,
      messsage: messsage ?? this.messsage,
    );
  }
}
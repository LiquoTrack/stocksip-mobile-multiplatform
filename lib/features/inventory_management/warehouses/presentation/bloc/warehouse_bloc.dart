import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/repositories/warehouse_repository.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseRepository repository;

  WarehouseBloc({required this.repository}) : super(const WarehouseState()) {
    on<GetAllWarehouses>(_onGetAllWarehouses);
  }

  Future<void> _onGetAllWarehouses(
    GetAllWarehouses event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      final warehouses = await repository.fetchWarehouses();

      final wrapper = state.warehouseWrapper.copyWith(
        warehouses: warehouses,
        total: warehouses.length,
      );

      emit(state.copyWith(status: Status.success, warehouseWrapper: wrapper));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, messsage: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/repositories/warehouse_repository.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseRepository repository;

  WarehouseBloc({required this.repository}) : super(const WarehouseState()) {
    on<GetAllWarehouses>(_onGetAllWarehouses);
    on<OnWarehouseDeleted>(_onWarehouseDeleted);
    on<OnWarehouseCreated>(_onCreateWarehouse);
    on<OnWarehouseUpdated>(_onUpdateWarehouse);

    on<OnWarehouseNameChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            name: event.name,
          ),
        ),
      ),
    );

    on<OnWarehouseStreetChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            addressStreet: event.street,
          ),
        ),
      ),
    );

    on<OnWarehouseCityChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            addressCity: event.city,
          ),
        ),
      ),
    );

    on<OnWarehouseDistrictChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            addressDistrict: event.district,
          ),
        ),
      ),
    );

    on<OnWarehousePostalCodeChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            addressPostalCode: event.postalCode,
          ),
        ),
      ),
    );

    on<OnWarehouseContryChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            addressCountry: event.country,
          ),
        ),
      ),
    );

    on<OnWarehouseCapacityChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            capacity: event.capacity,
          ),
        ),
      ),
    );

    on<OnMinTemperatureChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            temperatureMin: event.minTemperature,
          ),
        ),
      ),
    );

    on<OnMaxTemperatureChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedWarehouse: state.selectedWarehouse?.copyWith(
            temperatureMax: event.maxTemperature,
          ),
        ),
      ),
    );

    on<OnValidateTemperatureRange>((event, emit) {
      if (event.maxTemperature <= event.minTemperature) {
        emit(
          state.copyWith(
            status: Status.failure,
            messsage: 'Max temperature must be greater than min temperature',
          ),
        );
      } else {
        emit(state.copyWith(status: Status.success, messsage: null));
      }
    });
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

  Future<void> _onWarehouseDeleted(
    OnWarehouseDeleted event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      if (event.warehouseId.isEmpty) {
        throw Exception('Invalid warehouse ID');
      }

      await repository.deleteWarehouse(event.warehouseId);

      final updatedWarehouses = state.warehouseWrapper.warehouses
          .where((w) => w.warehouseId != event.warehouseId)
          .toList();

      final wrapper = state.warehouseWrapper.copyWith(
        warehouses: updatedWarehouses,
        total: updatedWarehouses.length,
      );

      emit(state.copyWith(status: Status.success, warehouseWrapper: wrapper, messsage: 'Warehouse deleted successfully'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, messsage: e.toString()));
    }
  }

  Future<void> _onCreateWarehouse(
    OnWarehouseCreated event,
    Emitter<WarehouseState> emit,
  ) async {
    try {

      emit(state.copyWith(status: Status.loading));

      final createdWarehouse = await repository.addWarehouse(event.warehouse, event.image);

      final updatedList = List.of(state.warehouseWrapper.warehouses)
        ..add(createdWarehouse);

      final wrapper = state.warehouseWrapper.copyWith(
        warehouses: updatedList,
        total: updatedList.length,
      );

      emit(state.copyWith(status: Status.success, warehouseWrapper: wrapper, messsage: 'Warehouse created successfully'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, messsage: e.toString()));
    }
  }

  Future<void> _onUpdateWarehouse(
    OnWarehouseUpdated event,
    Emitter<WarehouseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      await repository.updateWarehouse(event.warehouse);

      final warehouses = await repository.fetchWarehouses();

      final wrapper = state.warehouseWrapper.copyWith(
        warehouses: warehouses,
        total: warehouses.length,
      );

      emit(state.copyWith(status: Status.success, warehouseWrapper: wrapper, messsage: 'Warehouse updated successfully'));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, messsage: e.toString()));
    }
  }
}

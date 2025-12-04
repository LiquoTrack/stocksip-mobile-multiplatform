import 'dart:io';

import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

abstract class WarehouseEvent {
  const WarehouseEvent();
}

class OnWarehouseNameChanged extends WarehouseEvent {
  final String name;
  const OnWarehouseNameChanged({required this.name});
}

class OnWarehouseStreetChanged extends WarehouseEvent {
  final String street;
  const OnWarehouseStreetChanged({required this.street});
}

class OnWarehouseCityChanged extends WarehouseEvent {
  final String city;
  const OnWarehouseCityChanged({required this.city});
}

class OnWarehouseDistrictChanged extends WarehouseEvent {
  final String district;
  const OnWarehouseDistrictChanged({required this.district});
}

class OnWarehousePostalCodeChanged extends WarehouseEvent {
  final String postalCode;
  const OnWarehousePostalCodeChanged({required this.postalCode});
}

class OnWarehouseContryChanged extends WarehouseEvent {
  final String country;
  const OnWarehouseContryChanged({required this.country});
}

class OnWarehouseCapacityChanged extends WarehouseEvent {
  final double capacity;
  const OnWarehouseCapacityChanged({required this.capacity});
}

class OnMinTemperatureChanged extends WarehouseEvent {
  final double minTemperature;
  const OnMinTemperatureChanged({required this.minTemperature});
}

class OnMaxTemperatureChanged extends WarehouseEvent {
  final double maxTemperature;
  const OnMaxTemperatureChanged({required this.maxTemperature});
}

class OnWarehouseCreated extends WarehouseEvent {
  final Warehouse warehouse;
  final File? image;
  const OnWarehouseCreated({required this.warehouse, this.image});
}

class OnWarehouseUpdated extends WarehouseEvent {
  final Warehouse warehouse;
  final File? image;
  const OnWarehouseUpdated({required this.warehouse, this.image});
}

class OnWarehouseDeleted extends WarehouseEvent {
  const OnWarehouseDeleted();
}

class GetAllWarehouses extends WarehouseEvent {
  const GetAllWarehouses();
}

class OnValidateTemperatureRange extends WarehouseEvent {
  final double minTemperature;
  final double maxTemperature;
  const OnValidateTemperatureRange({
    required this.minTemperature,
    required this.maxTemperature,
  });
}
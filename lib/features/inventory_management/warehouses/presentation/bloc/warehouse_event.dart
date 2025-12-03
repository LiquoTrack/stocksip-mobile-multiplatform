import 'dart:ffi';

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
  final Double capacity;
  const OnWarehouseCapacityChanged({required this.capacity});
}

class OnMinTemperatureChanged extends WarehouseEvent {
  final Double minTemperature;
  const OnMinTemperatureChanged({required this.minTemperature});
}

class OnMaxTemperatureChanged extends WarehouseEvent {
  final Double maxTemperature;
  const OnMaxTemperatureChanged({required this.maxTemperature});
}

class OnWarehouseCreated extends WarehouseEvent {
  const OnWarehouseCreated();
}

class OnWarehouseUpdated extends WarehouseEvent {
  const OnWarehouseUpdated();
}

class OnWarehouseDeleted extends WarehouseEvent {
  const OnWarehouseDeleted();
}

class GetAllWarehouses extends WarehouseEvent {
  const GetAllWarehouses();
}
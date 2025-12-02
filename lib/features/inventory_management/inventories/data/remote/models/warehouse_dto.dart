import 'package:stocksip/features/inventory_management/inventories/domain/models/warehouse.dart';

class WarehouseDto {
  String warehouseId;
  String name;
  String addressStreet;
  String addressCity;
  String addressDistrict;
  String addressPostalCode;
  String addressCountry;
  int capacity;
  int temperatureMin;
  int temperatureMax;
  String imageUrl;

  WarehouseDto({
    required this.warehouseId,
    required this.name,
    required this.addressStreet,
    required this.addressCity,
    required this.addressDistrict,
    required this.addressPostalCode,
    required this.addressCountry,
    required this.capacity,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.imageUrl,
  });

  factory WarehouseDto.fromJson(Map<String, dynamic> json) {
    return WarehouseDto(
      warehouseId: json['warehouseId'] as String,
      name: json['name'] as String,
      addressStreet: json['addressStreet'] as String,
      addressCity: json['addressCity'] as String,
      addressDistrict: json['addressDistrict'] as String,
      addressPostalCode: json['addressPostalCode'] as String,
      addressCountry: json['addressCountry'] as String,
      capacity: json['capacity'] as int,
      temperatureMin: json['temperatureMin'] as int,
      temperatureMax: json['temperatureMax'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Warehouse toDomain() {
    return Warehouse(
      warehouseId: warehouseId,
      name: name,
      addressStreet: addressStreet,
      addressCity: addressCity,
      addressDistrict: addressDistrict,
      addressPostalCode: addressPostalCode,
      addressCountry: addressCountry,
      capacity: capacity,
      temperatureMin: temperatureMin,
      temperatureMax: temperatureMax,
      imageUrl: imageUrl,
    );
  }
}
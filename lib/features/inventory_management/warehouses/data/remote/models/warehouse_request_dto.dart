import 'dart:io';

class WarehouseRequestDto {
  String name;
  String addressStreet;
  String addressCity;
  String addressDistrict;
  String addressPostalCode;
  String addressCountry;
  double temperatureMin;
  double temperatureMax;
  double capacity;
  File? imageFile;

  WarehouseRequestDto({
    required this.name,
    required this.addressStreet,
    required this.addressCity,
    required this.addressDistrict,
    required this.addressPostalCode,
    required this.addressCountry,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.capacity,
    this.imageFile,
  });
}

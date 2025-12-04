class Warehouse {
  final String warehouseId;
  final String name;
  final String addressStreet;
  final String addressCity;
  final String addressDistrict;
  final String addressPostalCode;
  final String addressCountry;
  final int capacity;
  final int temperatureMin;
  final int temperatureMax;
  final String imageUrl;

  const Warehouse({
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

  Warehouse copyWith({
    String? warehouseId,
    String? name,
    String? addressStreet,
    String? addressCity,
    String? addressDistrict,
    String? addressPostalCode,
    String? addressCountry,
    int? capacity,
    int? temperatureMin,
    int? temperatureMax,
    String? imageUrl,
  }) {
    return Warehouse(
      warehouseId: warehouseId ?? this.warehouseId,
      name: name ?? this.name,
      addressStreet: addressStreet ?? this.addressStreet,
      addressCity: addressCity ?? this.addressCity,
      addressDistrict: addressDistrict ?? this.addressDistrict,
      addressPostalCode: addressPostalCode ?? this.addressPostalCode,
      addressCountry: addressCountry ?? this.addressCountry,
      capacity: capacity ?? this.capacity,
      temperatureMin: temperatureMin ?? this.temperatureMin,
      temperatureMax: temperatureMax ?? this.temperatureMax,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

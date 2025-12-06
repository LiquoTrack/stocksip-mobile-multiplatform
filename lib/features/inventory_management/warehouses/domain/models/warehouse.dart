class Warehouse {
  final String warehouseId;
  final String name;
  final String addressStreet;
  final String addressCity;
  final String addressDistrict;
  final String addressPostalCode;
  final String addressCountry;
  final double capacity;
  final double temperatureMin;
  final double temperatureMax;
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
    double? capacity,
    double? temperatureMin,
    double? temperatureMax,
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

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    // adaptamos a la estructura real que compartiste (address y temperature objetos)
    final address = json['address'] ?? {};
    final temperature = json['temperature'] ?? {};

    double parseNumToDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return Warehouse(
      warehouseId: (json['_id'] ?? json['warehouseId'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      addressStreet: (address['Street'] ?? address['street'] ?? '') as String,
      addressCity: (address['City'] ?? address['city'] ?? '') as String,
      addressDistrict: (address['District'] ?? address['district'] ?? '') as String,
      addressPostalCode: (address['PostalCode'] ?? address['postalCode'] ?? '') as String,
      addressCountry: (address['Country'] ?? address['country'] ?? '') as String,
      capacity: parseNumToDouble(json['capacity']),
      temperatureMin: parseNumToDouble(temperature['MinTemperature'] ?? temperature['minTemperature'] ?? temperature['MinTemperature']),
      temperatureMax: parseNumToDouble(temperature['MaxTemperature'] ?? temperature['maxTemperature'] ?? temperature['MaxTemperature']),
      imageUrl: (json['imageUrl'] ?? '') as String,
    );
  }
}

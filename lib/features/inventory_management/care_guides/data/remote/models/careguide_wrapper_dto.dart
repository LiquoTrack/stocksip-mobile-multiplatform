import 'careguide_dto.dart';

class CareguideWrapperDto {
  final int count;
  final List<CareguideDto> careGuides;

  const CareguideWrapperDto({required this.count, required this.careGuides});

  factory CareguideWrapperDto.fromJson(dynamic json) {
    if (json is List) {
      final list = json.map((e) => CareguideDto.fromJson(e as Map<String, dynamic>)).toList();
      return CareguideWrapperDto(count: list.length, careGuides: list);
    }
    if (json is Map<String, dynamic>) {
      final data = json['careGuides'] ?? json['items'] ?? json['data'] ?? [];
      final list = (data as List).map((e) => CareguideDto.fromJson(e as Map<String, dynamic>)).toList();
      final count = (json['count'] ?? json['total'] ?? list.length) as int;
      return CareguideWrapperDto(count: count, careGuides: list);
    }
    return const CareguideWrapperDto(count: 0, careGuides: []);
  }
}
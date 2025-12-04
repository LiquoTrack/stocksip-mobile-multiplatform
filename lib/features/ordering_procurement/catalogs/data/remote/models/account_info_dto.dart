import 'business_info_dto.dart';

class AccountInfoDto {
  final String id;
  final BusinessInfoDto business;

  AccountInfoDto({
    required this.id,
    required this.business,
  });

  factory AccountInfoDto.fromJson(Map<String, dynamic> json) {
    return AccountInfoDto(
      id: json['id'] as String,
      business: BusinessInfoDto.fromJson(json['business'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business': business.toJson(),
    };
  }
}

import 'account_info_dto.dart';
import 'catalog_dto.dart';

class SupplierInfoDto {
  final AccountInfoDto account;
  final List<CatalogDto> catalogs;

  SupplierInfoDto({
    required this.account,
    required this.catalogs,
  });

  factory SupplierInfoDto.fromJson(Map<String, dynamic> json) {
    return SupplierInfoDto(
      account: AccountInfoDto.fromJson(json['account'] as Map<String, dynamic>),
      catalogs: (json['catalogs'] as List<dynamic>?)
              ?.map((item) => CatalogDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account.toJson(),
      'catalogs': catalogs.map((item) => item.toJson()).toList(),
    };
  }
}

import 'package:stocksip/features/order_management/salesorder/data/remote/models/saleorder_dto.dart';

class SalesorderWrapperDto {
  final SaleorderDto order;

  const SalesorderWrapperDto({required this.order});

  factory SalesorderWrapperDto.fromJson(Map<String, dynamic> json) {
    return SalesorderWrapperDto(
      order: SaleorderDto.fromJson((json['order'] as Map).cast<String, dynamic>()),
    );
  }
}
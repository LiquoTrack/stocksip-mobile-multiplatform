import 'package:stocksip/features/order_management/salesorder/data/remote/models/saleorder_dto.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SalesorderMapper {
  static Saleorder toDomain(SaleorderDto dto) => dto.toDomain();
}
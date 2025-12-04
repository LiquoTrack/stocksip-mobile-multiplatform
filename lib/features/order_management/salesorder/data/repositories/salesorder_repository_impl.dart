import 'package:stocksip/features/order_management/salesorder/data/remote/mappers/salesorder_mapper.dart';
import 'package:stocksip/features/order_management/salesorder/data/remote/services/saleorder_service.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';
import 'package:stocksip/features/order_management/salesorder/domain/repositories/salesorder_repository.dart';

class SalesorderRepositoryImpl implements SalesorderRepository {
  final SaleorderService service;

  SalesorderRepositoryImpl({required this.service});

  @override
  Future<Saleorder> createFromProcurement(String purchaseOrderId) async {
    try {
      final dto = await service.createFromProcurement(purchaseOrderId);
      return SalesorderMapper.toDomain(dto);
    } catch (e) {
      throw Exception('Error creating sales order from procurement: $e');
    }
  }
}
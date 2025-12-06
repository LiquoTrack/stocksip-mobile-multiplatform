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

  @override
  Future<List<Saleorder>> getAllOrders({String? accountId}) async {
    try {
      final dtos = await service.getAllOrders(accountId: accountId);
      return dtos.map((dto) => SalesorderMapper.toDomain(dto)).toList();
    } catch (e) {
      throw Exception('Error fetching all orders: $e');
    }
  }

  @override
  Future<void> confirmOrder(String orderId) async {
    try {
      await service.confirmOrder(orderId);
    } catch (e) {
      throw Exception('Error confirming order: $e');
    }
  }

  @override
  Future<void> receiveOrder(String orderId) async {
    try {
      await service.receiveOrder(orderId);
    } catch (e) {
      throw Exception('Error receiving order: $e');
    }
  }

  @override
  Future<void> shipOrder(String orderId) async {
    try {
      await service.shipOrder(orderId);
    } catch (e) {
      throw Exception('Error shipping order: $e');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await service.cancelOrder(orderId);
    } catch (e) {
      throw Exception('Error canceling order: $e');
    }
  }
}

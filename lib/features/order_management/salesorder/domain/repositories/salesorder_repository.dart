 import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

abstract class SalesorderRepository {

  Future<Saleorder> createFromProcurement(String purchaseOrderId);
  
  Future<List<Saleorder>> getAllOrders({String? accountId});

  Future<void> confirmOrder(String orderId);

  Future<void> receiveOrder(String orderId);

  Future<void> shipOrder(String orderId);

  Future<void> cancelOrder(String orderId);
}

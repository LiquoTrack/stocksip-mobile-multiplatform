 import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

abstract class SalesorderRepository {

  Future<Saleorder> createFromProcurement(String purchaseOrderId);
}
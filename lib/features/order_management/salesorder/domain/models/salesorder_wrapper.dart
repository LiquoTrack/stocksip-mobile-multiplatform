import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SalesorderWrapper {
  final Saleorder order;

  const SalesorderWrapper({
    required this.order,
  });

  SalesorderWrapper copyWith({Saleorder? order}) =>
      SalesorderWrapper(order: order ?? this.order);
}
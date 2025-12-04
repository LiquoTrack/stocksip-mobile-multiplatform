import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SaleorderState {
  final Status status;
  final String? message;
  final List<Saleorder> orders;
  final Saleorder? lastCreated;
  final String purchaseOrderId;

  const SaleorderState({
    this.status = Status.initial,
    this.message,
    this.orders = const <Saleorder>[],
    this.lastCreated,
    this.purchaseOrderId = '',
  });

  SaleorderState copyWith({
    Status? status,
    String? message,
    List<Saleorder>? orders,
    Saleorder? lastCreated,
    String? purchaseOrderId,
    bool clearMessage = false,
  }) {
    return SaleorderState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      orders: orders ?? this.orders,
      lastCreated: lastCreated ?? this.lastCreated,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
    );
  }
}
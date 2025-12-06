abstract class SaleorderEvent {
  const SaleorderEvent();
}

class CreateFromProcurementEvent extends SaleorderEvent {
  final String purchaseOrderId;
  const CreateFromProcurementEvent(this.purchaseOrderId);
}

class GetAllOrdersEvent extends SaleorderEvent {
  final String? accountId;
  const GetAllOrdersEvent({this.accountId});
}

class ClearSaleorderMessage extends SaleorderEvent {
  const ClearSaleorderMessage();
}

class ConfirmOrderEvent extends SaleorderEvent {
  final String orderId;
  const ConfirmOrderEvent(this.orderId);
}

class ReceiveOrderEvent extends SaleorderEvent {
  final String orderId;
  const ReceiveOrderEvent(this.orderId);
}

class ShipOrderEvent extends SaleorderEvent {
  final String orderId;
  const ShipOrderEvent(this.orderId);
}

class CancelOrderEvent extends SaleorderEvent {
  final String orderId;
  const CancelOrderEvent(this.orderId);
}

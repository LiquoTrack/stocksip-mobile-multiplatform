abstract class SaleorderEvent {
  const SaleorderEvent();
}

class CreateFromProcurementEvent extends SaleorderEvent {
  final String purchaseOrderId;
  const CreateFromProcurementEvent(this.purchaseOrderId);
}

class ClearSaleorderMessage extends SaleorderEvent {
  const ClearSaleorderMessage();
}

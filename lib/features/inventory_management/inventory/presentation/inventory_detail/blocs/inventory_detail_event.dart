/// Events for InventoryDetailBloc
abstract class InventoryDetailEvent {
  const InventoryDetailEvent();
}

/// Event to load inventory detail by ID
class LoadInventoryDetailEvent extends InventoryDetailEvent {
  final String inventoryId;

  const LoadInventoryDetailEvent(this.inventoryId);
}
/// Inventory Event Definitions for Inventory Management Feature
abstract class InventoryEvent {
  const InventoryEvent();
}

/// Event to fetch inventories by a specific warehouse ID.
/// Requires the warehouse ID as a parameter.
class GetInventoriesByWarehouseIdEvent extends InventoryEvent {
  final String warehouseId;

  const GetInventoriesByWarehouseIdEvent(this.warehouseId);
}

/// Event to delete a specific inventory item.
/// Requires the inventory ID as a parameter.
class DeleteInventoryEvent extends InventoryEvent {
  final String inventoryId;

  const DeleteInventoryEvent(this.inventoryId);
}
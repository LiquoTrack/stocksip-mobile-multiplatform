import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/widgets/warehouse_selector_card.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

/// A widget that displays two columns: one for inventory products and another for all products
class WarehouseSelectorField extends StatelessWidget {
  final List<Warehouse> warehouses;

  final String? selectedWarehouseId;

  final void Function(String) onItemSelected;

  const WarehouseSelectorField({
    super.key,
    required this.warehouses,
    required this.selectedWarehouseId,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Warehouse",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT COLUMN → INVENTORY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Existing Warehouses",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  if (warehouses.isEmpty)
                    const Text(
                      "No products in inventory",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    ...warehouses.map(
                      (warehouse) => WarehouseSelectorCard(
                        warehouse: warehouse,
                        isSelected:
                            selectedWarehouseId == warehouse.warehouseId,
                        onTap: () => onItemSelected(
                          warehouse.warehouseId,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

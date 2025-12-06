import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/widgets/inventory_selector_card.dart';

class InventorySelectorField extends StatelessWidget {
  final List<InventoryResponse> inventories;
  final String? selectedProductId;
  final String? selectedInventoryId;
  final Function(String, String) onProductSelected;

  const InventorySelectorField({
    super.key,
    required this.inventories,
    required this.selectedProductId,
    required this.selectedInventoryId,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Product",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT COLUMN: INVENTORY PRODUCTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Existing Inventory",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (inventories.isEmpty)
                    const Text(
                      "No products in inventory",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    ...inventories.map(
                      (inv) => InventorySelectorCard(
                        inventory: inv,
                        isSelected: selectedProductId == inv.productId,
                        onTap: () => onProductSelected(inv.id, inv.productId),
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
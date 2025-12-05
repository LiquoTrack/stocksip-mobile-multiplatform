import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/widgets/inventory_selector_card.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/widgets/product_selector_card.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// A widget that displays two columns: one for inventory products and another for all products
class ProductDoubleSelectorField extends StatelessWidget {
  final List<ProductResponse> products;
  final List<InventoryResponse> inventories;
  final String? selectedProductId;
  final Function(String) onProductSelected;

  const ProductDoubleSelectorField({
    super.key,
    required this.products,
    required this.inventories,
    required this.selectedProductId,
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
                        onTap: () => onProductSelected(inv.productId),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // RIGHT COLUMN: ALL PRODUCTS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Products",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (products.isEmpty)
                    const Text(
                      "No products available",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    ...products.map(
                      (product) => ProductSelectorCard(
                        product: product,
                        isSelected: selectedProductId == product.id,
                        onTap: () => onProductSelected(product.id),
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
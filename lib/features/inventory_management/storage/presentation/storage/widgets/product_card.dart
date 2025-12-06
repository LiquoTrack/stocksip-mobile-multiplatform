import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// A card widget that displays product information and handles user interactions.
class ProductCard extends StatelessWidget {
  final ProductResponse product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStartSelecting;
  final VoidCallback? onStopSelecting;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onStartSelecting,
    this.onStopSelecting,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: () async {
            if (onStartSelecting != null) onStartSelecting!();

            final option = await showModalBottomSheet<String>(
              context: context,
              useSafeArea: true,
              showDragHandle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (sheetContext) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text("Edit product"),
                      onTap: () => Navigator.pop(sheetContext, "edit"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text(
                        "Delete product",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () => Navigator.pop(sheetContext, "delete"),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );

            if (onStopSelecting != null) onStopSelecting!();

            if (!context.mounted) return;

            if (option == "edit") {
              if (onEdit != null) onEdit!();
            }
            if (option == "delete") {
              if (onDelete != null) onDelete!();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${product.totalStockInStore} units in stock"),
                    Text("${product.content} ml"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
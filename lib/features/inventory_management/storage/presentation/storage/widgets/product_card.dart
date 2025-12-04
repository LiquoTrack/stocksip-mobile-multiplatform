import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/pages/product_detail_page.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/pages/create_or_edit_product_page.dart';

/// A card widget that displays product information and handles user interactions.
class ProductCard extends StatelessWidget {
  final ProductResponse product;
  final VoidCallback onStartSelecting; 
  final VoidCallback onStopSelecting; 

  const ProductCard({
    super.key,
    required this.product,
    required this.onStartSelecting,
    required this.onStopSelecting,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailPage()),
          );
        },

        onLongPress: () async {
          onStartSelecting();

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
                    title: const Text("Delete product",
                        style: TextStyle(color: Colors.red)),
                    onTap: () => Navigator.pop(sheetContext, "delete"),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          );

          onStopSelecting();

          if (option == "edit") {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => CreateOrEditProductPage(product: product),
            );
          }

          if (option == "delete") {
            context
                .read<StorageBloc>()
                .add(OnProductDeletedEvent(product.id));
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
                  Text(product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 4),
                  Text("${product.totalStockInStore} units in stock"),
                  const SizedBox(height: 4),
                  Text("${product.content} ml"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
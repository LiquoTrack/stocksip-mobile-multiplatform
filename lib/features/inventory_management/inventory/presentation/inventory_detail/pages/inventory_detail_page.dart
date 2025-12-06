import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_state.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/widgets/read_only_field.dart';

/// Page to display inventory details in a draggable scrollable sheet.
class InventoryDetailPage extends StatefulWidget {
  final String inventoryId;

  const InventoryDetailPage({super.key, required this.inventoryId});

  @override
  State<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends State<InventoryDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryDetailBloc>().add(
      LoadInventoryDetailEvent(widget.inventoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return BlocBuilder<InventoryDetailBloc, InventoryDetailState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2B000D)),
              );
            }

            if (state.status == Status.failure) {
              return Center(
                child: Text(
                  state.message ?? "An error occurred",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final inventory = state.selectedInventory;
            if (inventory == null) {
              return const Center(child: Text("Inventory not found"));
            }

            return Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top back button
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Product Image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: inventory.imageUrl.isNotEmpty
                            ? Image.network(
                                inventory.imageUrl,
                                height: 240,
                                width: 240,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 80),
                              )
                            : const SizedBox(
                                height: 240,
                                width: 240,
                                child: Icon(Icons.image, size: 80),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Name, Price and Expiration Date
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inventory.productName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1B2E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${inventory.unitPrice.toStringAsFixed(2)} ${inventory.currencyCode}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B4C5C),
                            ),
                          ),
                          if (inventory.expirationDate != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Expires on: ${inventory.expirationDate!.toLocal()}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5A3A47),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info grid
                    Row(
                      children: [
                        Expanded(
                          child: ReadOnlyField(
                            label: "Brand",
                            value: inventory.productBrand,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ReadOnlyField(
                            label: "Type",
                            value: inventory.productType,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ReadOnlyField(
                            label: "Minimum Stock",
                            value: inventory.minimumStock.toString(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ReadOnlyField(
                            label: "Current Stock",
                            value: inventory.currentStock.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

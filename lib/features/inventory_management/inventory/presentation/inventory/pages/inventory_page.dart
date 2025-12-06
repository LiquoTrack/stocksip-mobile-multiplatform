import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_state.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/widgets/inventory_card.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/pages/inventory_addition_page.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/pages/inventory_detail_page.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/pages/inventory_subtrack_page.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/pages/inventory_transfer_page.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

/// Page that displays the inventory for a specific warehouse.
class InventoryPage extends StatefulWidget {
  final String warehouseId;
  final bool isSelecting;

  const InventoryPage({
    super.key,
    required this.warehouseId,
    this.isSelecting = false,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(
      GetInventoriesByWarehouseIdEvent(widget.warehouseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E9E7),
        title: const Text("Inventories"),
      ),
      drawer: const DrawerNavigation(),
      backgroundColor: const Color(0xFFF3E9E7),
      body: BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state.status == Status.success && state.message.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state.status == Status.failure && state.message.isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Error"),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final inventories = state.inventories;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  if (inventories.isEmpty)
                    _buildEmptyState(context)
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: inventories.length,
                      itemBuilder: (context, index) {
                        final inventory = inventories[index];

                        return InventoryCard(
                          inventory: inventory,
                          onTap: () =>
                              _openInventoryDetail(inventory: inventory),
                          onStartSelecting: () =>
                              setState(() => isSelecting = true),
                          onStopSelecting: () =>
                              setState(() => isSelecting = false),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: isSelecting ? null : _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 50),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Add
          FloatingActionButton(
            heroTag: "btn_add",
            backgroundColor: const Color(0xFF2B000D),
            onPressed: () => _openDraggableForm(
              child: InventoryAdditionPage(warehouseId: widget.warehouseId),
            ),
            mini: true,
            child: const Icon(Icons.add, color: Colors.white),
          ),

          const SizedBox(width: 16),

          // Subtract
          FloatingActionButton(
            heroTag: "btn_subtract",
            backgroundColor: const Color(0xFF2B000D),
            onPressed: () => _openDraggableForm(
              child: InventorySubtrackPage(warehouseId: widget.warehouseId),
            ),
            mini: true,
            child: const Icon(Icons.remove, color: Colors.white),
          ),

          const SizedBox(width: 16),

          // Transfer
          FloatingActionButton(
            heroTag: "btn_transfer",
            backgroundColor: const Color(0xFF2B000D),
            onPressed: () =>
                _openDraggableForm(child: const InventoryTransferPage()),
            mini: true,
            child: const Icon(Icons.swap_horiz, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warehouse, size: 120, color: Colors.grey[400]),
            Text(
              "No inventory records found.\nPlease add a product to this warehouse to get started.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _openDraggableForm({required Widget child}) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 10),
              child: child,
            );
          },
        );
      },
    );

    if (result == true) {
      context.read<InventoryBloc>().add(
        GetInventoriesByWarehouseIdEvent(widget.warehouseId),
      );
    }
  }

  void _openInventoryDetail({required InventoryResponse inventory}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return InventoryDetailPage(inventoryId: inventory.id);
      },
    );
  }
}

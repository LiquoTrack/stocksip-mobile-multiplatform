import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/pages/inventory_page.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/pages/warehouse_create_and_edit_page.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class WarehousePage extends StatefulWidget {
  final bool isSelecting;
  const WarehousePage({super.key, this.isSelecting = false});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(const GetAllWarehouses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E9E7),
        title: const Text("Warehouses"),
      ),
      drawer: const DrawerNavigation(),
      backgroundColor: const Color(0xFFF3E9E7),

      body: BlocListener<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state.status == Status.success && state.messsage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.messsage)));
          }

          if (state.status == Status.failure && state.messsage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.messsage)));
          }
        },

        child: BlocBuilder<WarehouseBloc, WarehouseState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == Status.failure) {
              return Center(
                child: Text(
                  state.messsage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final warehouses = state.warehouseWrapper.warehouses;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(state, warehouses.length),
                  const SizedBox(height: 12),

                  if (warehouses.isEmpty)
                    _buildEmptyState(context)
                  else
                    Column(
                      children: warehouses.map((warehouse) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,

                            child: InkWell(
                              onTap: () {
                                if (isSelecting) return;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InventoryPage(warehouseId: warehouse.warehouseId),
                                  ),
                                );
                              },

                              onLongPress: () async {
                                setState(() => isSelecting = true);

                                final option =
                                    await showModalBottomSheet<String>(
                                      context: context,
                                      useSafeArea: true,
                                      showDragHandle: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      builder: (sheetContext) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: const Text(
                                                "Edit warehouse",
                                              ),
                                              onTap: () => Navigator.pop(
                                                sheetContext,
                                                "edit",
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              title: const Text(
                                                "Delete warehouse",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () => Navigator.pop(
                                                sheetContext,
                                                "delete",
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                    );

                                setState(() => isSelecting = false);

                                if (!mounted) return;

                                if (option == "edit") {
                                  _openDraggableForm(
                                    child: CreateAndEditWarehousePage(
                                      warehouse: warehouse,
                                    ),
                                  );
                                }

                                if (option == "delete") {
                                  context.read<WarehouseBloc>().add(
                                    OnWarehouseDeleted(
                                      warehouseId: warehouse.warehouseId,
                                    ),
                                  );
                                }
                              },

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: warehouse.imageUrl,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          warehouse.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${warehouse.addressStreet}, ${warehouse.addressCity}",
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${warehouse.capacity} m³ Capacity",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: isSelecting
          ? null
          : FloatingActionButton(
              backgroundColor: const Color(0xFF2B000D),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _openDraggableForm(child: const CreateAndEditWarehousePage());
              },
            ),
    );
  }

  Widget _buildHeader(WarehouseState state, int current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Current: $current",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Max Allowed: ${state.warehouseWrapper.maxWarehousesAllowed}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              "No warehouses found.\nPlease add a warehouse to get started.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _openDraggableForm({required Widget child}) {
    showModalBottomSheet(
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
  }
}

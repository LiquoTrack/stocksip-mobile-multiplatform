import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/pages/product_detail_page.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/pages/create_or_edit_product_page.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/widgets/product_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

/// The main page for managing storage and products.
class StoragePage extends StatefulWidget {
  final bool isSelecting;

  const StoragePage({super.key, this.isSelecting = false});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    context.read<StorageBloc>().add(GetAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E9E7),
        title: const Text("Storage"),
      ),
      drawer: const DrawerNavigation(),
      backgroundColor: const Color(0xFFF3E9E7),
      body: BlocListener<StorageBloc, StorageState>(
        listener: (context, state) {
          if (state.status == Status.success && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
        child: BlocBuilder<StorageBloc, StorageState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = state.products.products;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(state, products.length),
                  const SizedBox(height: 12),
                  if (products.isEmpty)
                    _buildEmptyState(context)
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onTap: () => _openProductDetail(product: product),
                          onEdit: () => _openDraggableForm(
                            child: CreateOrEditProductPage(product: product),
                          ),
                          onStartSelecting: () => setState(() => isSelecting = true),
                          onStopSelecting: () => setState(() => isSelecting = false),
                        );
                      },
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
                _openDraggableForm(child: const CreateOrEditProductPage());
              },
            ),
    );
  }

  Widget _buildHeader(StorageState state, int current) {
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
            "Max Allowed: ${state.products.maxTotalAllowed}",
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
              "No products found.\nPlease add a product to get started.",
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

  void _openProductDetail({required ProductResponse product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ProductDetailPage(productId: product.id);
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';

class AddCatalogItemsPage extends StatefulWidget {
  final String catalogId;

  const AddCatalogItemsPage({
    super.key,
    required this.catalogId,
  });

  @override
  State<AddCatalogItemsPage> createState() => _AddCatalogItemsPageState();
}

class _AddCatalogItemsPageState extends State<AddCatalogItemsPage> {
  String _searchQuery = '';
  String? _selectedWarehouseId;
  final Map<String, int> _selectedStocks = {};

  @override
  void initState() {
    super.initState();
    // Load products when page initializes
    context.read<StorageBloc>().add(GetProductsByAccountIdEvent());
    // Load warehouses
    context.read<WarehouseBloc>().add(GetAllWarehouses());
  }

  void _addSelectedItems() {
    if (_selectedStocks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one product')),
      );
      return;
    }

    if (_selectedWarehouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a warehouse')),
      );
      return;
    }

    // Add items to catalog
    for (final entry in _selectedStocks.entries) {
      context.read<CatalogBloc>().add(
            AddCatalogItem(
              catalogId: widget.catalogId,
              productId: entry.key,
              warehouseId: _selectedWarehouseId!,
              stock: entry.value,
            ),
          );
    }

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Items added to catalog')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null && state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Items to Catalog'),
          backgroundColor: const Color(0xFFF4ECEC),
          foregroundColor: const Color(0xFF4A1B2A),
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF4ECEC),
        body: BlocBuilder<StorageBloc, StorageState>(
          builder: (context, storageState) {
            if (storageState.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF5C1F2E),
                  ),
                ),
              );
            }

            if (storageState.status == Status.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      storageState.message ?? 'Failed to load products',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final products = storageState.products;
            final filteredProducts = products
                .where((product) => product.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Warehouse Selection
                    Text(
                      'Select Warehouse',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFE8B4BE),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    BlocBuilder<WarehouseBloc, WarehouseState>(
                      builder: (context, warehouseState) {
                        final warehouses =
                            warehouseState.warehouseWrapper.warehouses;

                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('Choose a warehouse'),
                              value: _selectedWarehouseId,
                              underline: const SizedBox(),
                              items: warehouses
                                  .map((warehouse) => DropdownMenuItem(
                                        value: warehouse.warehouseId,
                                        child: Text(warehouse.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _selectedWarehouseId = value);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Products List
                    Text(
                      'Available Products',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFE8B4BE),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    if (filteredProducts.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final isSelected = _selectedStocks.containsKey(product.id);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: isSelected
                                  ? const Color(0xFFE8B4BE).withOpacity(0.1)
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Header with Checkbox
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                _selectedStocks[product.id] = 1;
                                              } else {
                                                _selectedStocks.remove(product.id);
                                              }
                                            });
                                          },
                                          activeColor:
                                              const Color(0xFF5C1F2E),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  color: Color(0xFF8B4C5C),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                '\$${product.unitPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  color: Color(0xFF8B4C5C),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(height: 12.0),
                                      // Stock Input
                                      Row(
                                        children: [
                                          const SizedBox(width: 40.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Available: ${product.totalStockInStore}',
                                                  style: const TextStyle(
                                                    color:
                                                        Color(0xFFE8B4BE),
                                                    fontSize: 11.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      InputDecoration(
                                                    hintText:
                                                        'Enter quantity',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8.0),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    final stock =
                                                        int.tryParse(value) ??
                                                            1;
                                                    setState(() {
                                                      _selectedStocks[
                                                          product.id] = stock;
                                                    });
                                                  },
                                                  controller: TextEditingController(
                                                    text: _selectedStocks[
                                                            product.id]
                                                        .toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 24.0),
                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _addSelectedItems,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C1F2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: const Text(
                          'Add Selected Items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

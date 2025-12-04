import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';

class CatalogCreateEditPage extends StatefulWidget {
  final String? catalogId;
  final bool isEditMode;

  const CatalogCreateEditPage({
    super.key,
    this.catalogId,
    this.isEditMode = false,
  });

  @override
  State<CatalogCreateEditPage> createState() => _CatalogCreateEditPageState();
}

class _CatalogCreateEditPageState extends State<CatalogCreateEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  bool _isPublished = false;
  String _searchQuery = '';
  String? _selectedWarehouseId;
  final Map<String, int> _selectedItems = {}; // productId -> quantity

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();

    if (widget.isEditMode && widget.catalogId != null) {
      context.read<CatalogBloc>().add(
            LoadCatalogById(catalogId: widget.catalogId!),
          );
    }
    
    // Load products and warehouses
    context.read<StorageBloc>().add(GetProductsByAccountIdEvent());
    context.read<WarehouseBloc>().add(GetAllWarehouses());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<CatalogBloc>().state;
    if (widget.isEditMode && state.selectedCatalog != null) {
      final catalog = state.selectedCatalog!;
      _nameController.text = catalog.name;
      _descriptionController.text = catalog.description;
      _emailController.text = catalog.contactEmail;
      _isPublished = catalog.isPublished;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveCatalog(BuildContext context) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a catalog name')),
      );
      return;
    }

    if (widget.isEditMode && widget.catalogId != null) {
      context.read<CatalogBloc>().add(
            UpdateCatalog(
              catalogId: widget.catalogId!,
              name: name,
              description: description,
              contactEmail: email,
            ),
          );
      if (_isPublished) {
        context.read<CatalogBloc>().add(
              PublishCatalog(catalogId: widget.catalogId!),
            );
      } else {
        context.read<CatalogBloc>().add(
              UnpublishCatalog(catalogId: widget.catalogId!),
            );
      }
      
      // Add selected items in edit mode
      _addSelectedItems(widget.catalogId!);
    } else {
      // For create, get account ID from storage
      final tokenStorage = TokenStorage();
      final accountId = await tokenStorage.readAccountId();
      
      if (accountId != null) {
        context.read<CatalogBloc>().add(
              CreateCatalog(
                accountId: accountId,
                name: name,
                description: description,
                contactEmail: email,
              ),
            );
        
        // Add selected items after creating the catalog
        // Note: catalogId will be available in the state after creation
        Future.delayed(const Duration(milliseconds: 500), () {
          final catalogId = context.read<CatalogBloc>().state.selectedCatalog?.id;
          if (catalogId != null) {
            _addSelectedItems(catalogId);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Account ID not found')),
        );
        return;
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _addSelectedItems(String catalogId) {
    if (_selectedItems.isEmpty || _selectedWarehouseId == null) {
      return;
    }

    for (final entry in _selectedItems.entries) {
      context.read<CatalogBloc>().add(
            AddCatalogItem(
              catalogId: catalogId,
              productId: entry.key,
              warehouseId: _selectedWarehouseId!,
              stock: entry.value,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditMode ? 'Edit Catalog' : 'Create Catalog'),
          backgroundColor: const Color(0xFFF4ECEC),
          foregroundColor: const Color(0xFF4A1B2A),
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF4ECEC),
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Catalog Info Section
                    Text(
                      'Catalog Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFE8B4BE),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Catalog name',
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
                    const SizedBox(height: 12.0),
                    // Description Field
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
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
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12.0),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Contact email',
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
                    const SizedBox(height: 24.0),
                    // Status Section (only for edit mode)
                    if (widget.isEditMode) ...[
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFFE8B4BE),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Publish',
                                style: TextStyle(
                                  color: Color(0xFF8B4C5C),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Switch(
                                value: _isPublished,
                                onChanged: (value) {
                                  setState(() => _isPublished = value);
                                },
                                activeColor: const Color(0xFFE8B4BE),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                    // Items Section
                    Text(
                      'Add Items (Optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFE8B4BE),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12.0),
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
                    const SizedBox(height: 12.0),
                    // Warehouse Selection
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
                              hint: const Text('Select warehouse'),
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
                    const SizedBox(height: 12.0),
                    // Products List
                    BlocBuilder<StorageBloc, StorageState>(
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
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Error loading products',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    storageState.message ?? 'Unknown error',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final filteredProducts = storageState.products
                            .where((product) => product.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    _searchQuery.isEmpty ? 'No products available' : 'No products found',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final isSelected =
                                _selectedItems.containsKey(product.id);

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Header with Checkbox
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value == true) {
                                                  _selectedItems[product.id] =
                                                      1;
                                                } else {
                                                  _selectedItems
                                                      .remove(product.id);
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
                                                    fontWeight:
                                                        FontWeight.w600,
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
                                                    fontWeight:
                                                        FontWeight.bold,
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
                                                    CrossAxisAlignment
                                                        .start,
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
                                                        _selectedItems[
                                                            product.id] = stock;
                                                      });
                                                    },
                                                    controller:
                                                        TextEditingController(
                                                      text: _selectedItems[
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
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: state.status == Status.loading
                            ? null
                            : () => _saveCatalog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C1F2E),
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: state.status == Status.loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.isEditMode ? 'Save Changes' : 'Create',
                                style: const TextStyle(
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

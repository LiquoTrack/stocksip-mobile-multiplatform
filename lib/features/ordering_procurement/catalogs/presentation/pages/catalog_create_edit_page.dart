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
  late List<TextEditingController> _controllers;
  bool _isPublished = false;
  String _searchQuery = '';
  String? _selectedWarehouseId;
  final Map<String, int> _selectedItems = {};
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();

    _controllers = [
      _nameController,
      _descriptionController,
      _emailController,
    ];

    if (widget.isEditMode && widget.catalogId != null) {
      context.read<CatalogBloc>().add(
            LoadCatalogById(catalogId: widget.catalogId!),
          );
    }

    context.read<WarehouseBloc>().add(GetAllWarehouses());

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _nameController.text.isNotEmpty;
    if (allFilled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = allFilled;
      });
    }
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
      _updateButtonState();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveCatalog() async {
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

      _addSelectedItems(widget.catalogId!);
    } else {
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
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditMode ? 'Edit Catalog' : 'New Catalog',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C1F2E),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Catalog Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'E.g., Premium Wines',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Catalog description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Contact Email',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'contact@example.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.isEditMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Publish',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
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
              Text(
                'Select Warehouse',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<WarehouseBloc, WarehouseState>(
                builder: (context, warehouseState) {
                  final warehouses = warehouseState.warehouseWrapper.warehouses;

                  return GestureDetector(
                    onTap: warehouses.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Select Warehouse',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      if (warehouses.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(
                                            child: Text(
                                              'No warehouses available',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                          ),
                                        )
                                      else
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: warehouses.length,
                                          itemBuilder: (context, index) {
                                            final warehouse = warehouses[index];
                                            final isSelected =
                                                _selectedWarehouseId ==
                                                    warehouse.warehouseId;
                                            return ListTile(
                                              title: Text(warehouse.name),
                                              trailing: isSelected
                                                  ? const Icon(Icons.check,
                                                      color: Color(0xFF5C1F2E))
                                                  : null,
                                              onTap: () {
                                                setState(() =>
                                                    _selectedWarehouseId =
                                                        warehouse.warehouseId);
                                                context
                                                    .read<StorageBloc>()
                                                    .add(
                                                      GetProductsByWarehouseIdEvent(
                                                        warehouseId: warehouse
                                                            .warehouseId,
                                                      ),
                                                    );
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: warehouses.isEmpty
                              ? Colors.grey[300]!
                              : Colors.grey[400]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 14.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedWarehouseId == null
                                  ? warehouses.isEmpty
                                      ? 'No warehouses available'
                                      : 'Select warehouse'
                                  : warehouses
                                      .firstWhere(
                                        (w) =>
                                            w.warehouseId ==
                                            _selectedWarehouseId,
                                        orElse: () => warehouses.isNotEmpty
                                            ? warehouses.first
                                            : null as dynamic,
                                      )
                                      .name,
                              style: TextStyle(
                                color: _selectedWarehouseId == null
                                    ? Colors.grey[600]
                                    : Colors.black,
                                fontSize: 14.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (warehouses.isNotEmpty)
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Add Items (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
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
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedWarehouseId == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.warehouse_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Select a warehouse first',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Choose a warehouse to see available products',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                BlocBuilder<StorageBloc, StorageState>(
                  builder: (context, storageState) {
                    if (storageState.status == Status.loading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey[400]!,
                            ),
                          ),
                        ),
                      );
                    }

                    if (storageState.status == Status.failure) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
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
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                storageState.message ?? 'Unknown error',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.red,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final filteredProducts = storageState.products.products
                        .where((product) => product.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                    if (filteredProducts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No products available'
                                    : 'No products found',
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8B4BE).withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedItems[product.id] = 1;
                                            } else {
                                              _selectedItems
                                                  .remove(product.id);
                                            }
                                          });
                                        },
                                        activeColor: const Color(0xFF5C1F2E),
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
                                              overflow: TextOverflow.ellipsis,
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
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0, 12.0, 12.0),
                                    child: Row(
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
                                                  color: Color(0xFFE8B4BE),
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Decrease Button
                                                    SizedBox(
                                                      width: 40,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            final current =
                                                                _selectedItems[
                                                                    product
                                                                        .id] ??
                                                                    1;
                                                            if (current > 1) {
                                                              _selectedItems[
                                                                  product
                                                                      .id] =
                                                                  current - 1;
                                                            }
                                                          });
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                      ),
                                                    ),
                                                    // Text Display
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          (_selectedItems[
                                                                  product
                                                                      .id] ??
                                                              1)
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Increase Button
                                                    SizedBox(
                                                      width: 40,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            final current =
                                                                _selectedItems[
                                                                    product
                                                                        .id] ??
                                                                    1;
                                                            if (current <
                                                                product
                                                                    .totalStockInStore) {
                                                              _selectedItems[
                                                                  product
                                                                      .id] =
                                                                  current + 1;
                                                            }
                                                          });
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 28),
              BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled && state.status != Status.loading
                          ? _saveCatalog
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled
                            ? const Color(0xFF5C1F2E)
                            : Colors.grey[400],
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              widget.isEditMode
                                  ? 'Save Changes'
                                  : 'Create',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

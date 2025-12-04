import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import '../../domain/models/catalog.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import 'catalog_create_edit_page.dart';

class CatalogDetailPage extends StatefulWidget {
  final String catalogId;

  const CatalogDetailPage({
    super.key,
    required this.catalogId,
  });

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(
          LoadCatalogById(catalogId: widget.catalogId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final catalog = state.selectedCatalog;

        return Scaffold(
          appBar: AppBar(
            title: Text(catalog?.name ?? 'Catalog Detail'),
            backgroundColor: const Color(0xFFF4ECEC),
            foregroundColor: const Color(0xFF4A1B2A),
            elevation: 0,
            actions: [
              if (catalog != null)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatalogCreateEditPage(
                          catalogId: catalog.id,
                          isEditMode: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFF8B4C5C),
                  ),
                ),
            ],
          ),
          backgroundColor: const Color(0xFFF4ECEC),
          body: state.status == Status.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF5C1F2E),
                    ),
                  ),
                )
              : catalog == null
                  ? Center(
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
                            'Catalog not found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: _buildProductList(catalog),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildProductList(Catalog catalog) {
    final filteredItems = catalog.catalogItems
        .where((item) => item.productName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
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
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildProductCard(item),
        );
      },
    );
  }

  Widget _buildProductCard(CatalogItem item) {
    final formattedPrice = item.amount != null
        ? '${item.currency ?? '\$'} ${item.amount?.toStringAsFixed(2) ?? '0.00'}'
        : 'N/A';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 60.0,
                height: 60.0,
                color: const Color(0xFFF4ECEC),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.shopping_bag,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12.0),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.productName,
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
                    formattedPrice,
                    style: const TextStyle(
                      color: Color(0xFF8B4C5C),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Stock: ${item.availableStock}',
                    style: const TextStyle(
                      color: Color(0xFFE8B4BE),
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            // Remove Button
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remove Item'),
                    content: const Text('Are you sure you want to remove this item from the catalog?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CatalogBloc>().add(
                            RemoveCatalogItem(
                              catalogId: context.read<CatalogBloc>().state.selectedCatalog?.id ?? '',
                              productId: item.productId,
                            ),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item removed from catalog')),
                          );
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFE8B4BE),
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

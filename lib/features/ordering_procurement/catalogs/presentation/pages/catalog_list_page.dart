import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';
import '../../domain/models/catalog.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import 'catalog_detail_page.dart';
import 'catalog_create_edit_page.dart';

class CatalogListPage extends StatefulWidget {
  const CatalogListPage({super.key});

  @override
  State<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends State<CatalogListPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
  }

  Future<void> _loadCatalogs() async {
    final tokenStorage = TokenStorage();
    final accountId = await tokenStorage.readAccountId();
    
    if (accountId != null && mounted) {
      context.read<CatalogBloc>().add(
            LoadCatalogsByAccountId(accountId: accountId),
          );
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          _showMessage(state.message!);
          context.read<CatalogBloc>().add(const ClearMessage());
        }
      },
      child: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          final filteredCatalogs = state.catalogs
              .where((catalog) =>
                  catalog.name.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Catalogs"),
              backgroundColor: const Color(0xFFF4ECEC),
              elevation: 0,
              foregroundColor: const Color(0xFF4A1B2A),
            ),
            drawer: const DrawerNavigation(),
            backgroundColor: const Color(0xFFF4ECEC),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatalogCreateEditPage(
                      isEditMode: false,
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xFF5C1F2E),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: state.status == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF5C1F2E),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: [
                              // Search Bar
                              TextField(
                                onChanged: (value) {
                                  setState(() => _searchQuery = value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search catalogs',
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
                              // Banner Card
                              _buildBannerCard(context),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                        // Catalogs List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: state.catalogs.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No catalogs yet',
                                        style:
                                            Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Create your first catalog to get started',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : filteredCatalogs.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No catalogs found',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: filteredCatalogs.length,
                                      itemBuilder: (context, index) {
                                        final catalog =
                                            filteredCatalogs[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                          ),
                                          child: _buildCatalogCard(catalog),
                                        );
                                      },
                                    ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: const Color(0xFFB8838E),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Your Own Catalog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CatalogCreateEditPage(
                            isEditMode: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C1F2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                    ),
                    child: const Text(
                      'New Catalog',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: 120.0,
                height: 120.0,
                color: const Color(0xFFF4ECEC),
                child: Image.asset(
                  'assets/images/wines_banner.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.wine_bar,
                        size: 48.0,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogCard(Catalog catalog) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CatalogDetailPage(
              catalogId: catalog.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catalog.name,
                      style: const TextStyle(
                        color: Color(0xFF8B4C5C),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      catalog.description,
                      style: const TextStyle(
                        color: Color(0xFFE8B4BE),
                        fontSize: 12.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Chip(
                      label: Text(
                        catalog.isPublished ? 'Published' : 'Draft',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: catalog.isPublished
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: catalog.isPublished
                          ? Colors.green[100]
                          : Colors.orange[100],
                      side: BorderSide.none,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${catalog.catalogItems.length}',
                    style: const TextStyle(
                      color: Color(0xFF8B4C5C),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'items',
                    style: TextStyle(
                      color: Color(0xFFE8B4BE),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


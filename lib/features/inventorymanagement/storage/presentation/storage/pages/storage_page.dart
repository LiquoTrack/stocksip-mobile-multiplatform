import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_state.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/widgets/product_list.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class StoragePage extends StatefulWidget {
  final void Function(String route) onNavigate;
  final VoidCallback onLogout;

  const StoragePage({
    super.key,
    required this.onNavigate, 
    required this.onLogout
  });

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load products when screen is initialized
    context.read<StorageBloc>().add(GetProductsByAccountIdEvent());
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF4ECEC);

    return Scaffold(
      key: _scaffoldKey,

      drawer: const DrawerNavigation(),
      
      appBar: AppBar(
        title: const Text("Storage"),
        backgroundColor: backgroundColor,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: BlocBuilder<StorageBloc, StorageState>(
        builder: (context, state) {
          // Loading state
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state.status == Status.failure) {
            return Center(
              child: Text(
                state.message ?? "An error occurred",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final products = state.products;
          final totalProducts = products.length;
          final maxProductsAllowed = 100;
          final isMaxReached = totalProducts >= maxProductsAllowed;

          return Column(
            children: [
              // Header con información de stock y botón agregar
              Container(
                width: double.infinity,
                color: const Color(0xFFE0DCDC), // Ajusta color según tu tema
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Current: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "$totalProducts",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              "Max: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "$maxProductsAllowed",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: isMaxReached
                          ? null
                          : () => widget.onNavigate("product_create_edit/new"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 36),
                      ),
                      child: const Text("+ New Product"),
                    ),
                  ],
                ),
              ),
              // Lista de productos
              Expanded(
                child: ProductList(
                  products: products,
                  onProductClick: (product) =>
                      widget.onNavigate("product_detail/${product.id}"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
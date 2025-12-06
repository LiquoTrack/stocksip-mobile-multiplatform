import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_state.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/widgets/read_only_field.dart';

/// Page that displays detailed information about a specific product.
class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(
      LoadProductDetailEvent(widget.productId),
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
        return BlocBuilder<ProductDetailBloc, ProductDetailState>(
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

            final product = state.selectedProduct;
            if (product == null) {
              return const Center(child: Text("Product not found"));
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
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
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

                    // Name & Price
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
                            product.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1B2E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${product.unitPrice.toStringAsFixed(2)} ${product.code}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B4C5C),
                            ),
                          ),
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
                            value: product.brand,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ReadOnlyField(
                            label: "Type",
                            value: product.type,
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
                            value: product.minimumStock.toString(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ReadOnlyField(
                            label: "Total Stock",
                            value: product.totalStockInStore.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ReadOnlyField(
                      label: "Content",
                      value: "${product.content} ml",
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

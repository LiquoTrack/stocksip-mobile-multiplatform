import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/widgets/product_card.dart';

/// A widget that displays a list of products using [ProductCard] widgets.
/// Parameters:
/// - [products]: A list of products to display.
/// - [onProductClick]: A callback function that is triggered when a product card is clicked, receiving the clicked [ProductResponse].
class ProductList extends StatelessWidget {
  final List<ProductResponse> products;
  final void Function(ProductResponse) onProductClick;

  const ProductList({
    super.key,
    required this.products,
    required this.onProductClick,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.liquor,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              "You don't have any products yet.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Tap the button above to create one.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final productItem = products[index];
            return ProductCard(
              product: productItem,
              onClick: () => onProductClick(productItem),
            );
          },
        ),
      );
    }
  }
}
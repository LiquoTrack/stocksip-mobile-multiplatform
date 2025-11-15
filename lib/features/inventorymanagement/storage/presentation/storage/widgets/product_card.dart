import 'package:flutter/material.dart';
import 'package:stocksip/features/inventorymanagement/storage/domain/product_response.dart';

/// A card widget that displays product information including image, name, stock, and price.
/// It is clickable and triggers the [onClick] callback when tapped.
/// Parameters:
/// - [product]: The product data to display.
/// - [onClick]: The callback function to execute when the card is tapped.
class ProductCard extends StatelessWidget {
  final ProductResponse product;
  final VoidCallback onClick;

  const ProductCard({
    super.key, 
    required this.product, 
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: const Color(0xFFFFFFFF),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Column(
            children: [
              // 🔹 Imagen
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              // Divider
              const Divider(
                color: Color(0xFFE0E0E0),
                height: 1,
                thickness: 1,
              ),

              // Product Info
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A1B2A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Total Stock and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Total Stock
                        Row(
                          children: [
                            const Text(
                              "Stock: ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            Text(
                              product.totalStockInStore.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A1B2A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Unit Price
                        Row(
                          children: [
                            const Text(
                              "Price: ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            Text(
                              "${product.code} ${product.unitPrice}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A1B2A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
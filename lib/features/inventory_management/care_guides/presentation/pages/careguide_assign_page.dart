import 'package:flutter/material.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/product_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';

class CareGuideAssignPage extends StatefulWidget {
  final CareGuide careGuide;

  const CareGuideAssignPage({
    super.key,
    required this.careGuide,
  });

  @override
  State<CareGuideAssignPage> createState() => _CareGuideAssignPageState();
}

class _CareGuideAssignPageState extends State<CareGuideAssignPage> {
  final _formKey = GlobalKey<FormState>();
  Product? _selectedProduct;
  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final accountId = await TokenStorage().readAccountId() ?? '';
      if (accountId.isNotEmpty) {
        final productService = ProductService(client: AuthHttpClient());
        final products = await productService.getProductsByAccountId(accountId);
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4ECEC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(color: const Color(0xFFE0D4D4)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: StatefulBuilder(
                builder: (context, setState) => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Assign Care Guide',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B000D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0D4D4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.careGuide.productName.isNotEmpty ? widget.careGuide.productName : widget.careGuide.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2B000D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.careGuide.summary,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B000D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_products.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: const Text(
                            'No products available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Product>(
                              value: _selectedProduct,
                              hint: const Text(
                                'Select a product',
                                style: TextStyle(color: Colors.grey),
                              ),
                              isExpanded: true,
                              items: _products.map((product) {
                                return DropdownMenuItem<Product>(
                                  value: product,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2B000D),
                                        ),
                                      ),
                                      Text(
                                        '${product.type} • Qty: ${product.quantity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (Product? product) {
                                setState(() {
                                  _selectedProduct = product;
                                });
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedProduct == null ? null : () async {
                            try {
                              final repository = CareguideRepositoryImpl(
                                service: CareguideService(client: AuthHttpClient()),
                              );

                              await repository.assignCareGuide(
                                careGuideId: widget.careGuide.id,
                                productId: _selectedProduct!.id,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Care guide assigned successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error assigning care guide: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C1F24),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Assign Guide', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

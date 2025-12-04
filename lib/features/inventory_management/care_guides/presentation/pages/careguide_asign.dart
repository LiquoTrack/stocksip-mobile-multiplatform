import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

class CareGuideAssign extends StatefulWidget {
  final String careGuideId;
  const CareGuideAssign({super.key, required this.careGuideId});

  @override
  State<CareGuideAssign> createState() => _CareGuideAssignState();
}

class _CareGuideAssignState extends State<CareGuideAssign> {
  final _storage = const FlutterSecureStorage();
  final _productRepo = ProductRepositoryImpl(service: ProductService(client: AuthHttpClient()), tokenStorage: TokenStorage());
  final _careRepo = CareguideRepositoryImpl(service: CareguideService());

  List<ProductResponse> _products = [];
  String? _selectedProductId;
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final accountId = await _storage.read(key: 'accountId');
      if (accountId == null || accountId.isEmpty) {
        setState(() {
          _error = 'No account found';
          _loading = false;
        });
        return;
      }
      final result = await _productRepo.getAllProductsByAccountId();
      setState(() {
        _products = result.products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products: $e';
        _loading = false;
      });
    }
  }

  Future<void> _assign() async {
    if (_selectedProductId == null) return;
    setState(() => _submitting = true);
    try {
      await _careRepo.assignCareGuide(careGuideId: widget.careGuideId, productId: _selectedProductId!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide assigned successfully')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to assign: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color pageBg = const Color(0xFFF3E9E7);
    final Color accent = const Color(0xFF471725);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF471725)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Assign Guide', style: TextStyle(color: Color(0xFF471725), fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedProductId,
                            decoration: InputDecoration(
                              hintText: 'Select Product',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF471725)),
                            items: _products
                                .map((p) => DropdownMenuItem(
                                      value: p.id,
                                      child: Text(p.name),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedProductId = v),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_selectedProductId == null || _submitting) ? null : _assign,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(_submitting ? 'Assigning...' : 'Assign'),
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}
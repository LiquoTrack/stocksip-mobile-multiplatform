import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_request.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/services/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/domain/entities/product_response.dart';

class CareGuideCreate extends StatefulWidget {
  const CareGuideCreate({super.key});

  @override
  State<CareGuideCreate> createState() => _CareGuideCreateState();
}

class _CareGuideCreateState extends State<CareGuideCreate> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProductId;
  final _typeController = TextEditingController();
  final _commentsController = TextEditingController();
  final _minTempController = TextEditingController();
  final _maxTempController = TextEditingController();

  final _storage = const FlutterSecureStorage();
  final _productRepo = ProductRepositoryImpl(service: ProductService());
  final _careRepo = CareguideRepositoryImpl(service: CareguideService());

  List<ProductResponse> _products = [];
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
      final accountId = await _storage.read(key: 'accountId') ?? await _storage.read(key: 'account_id');
      if (accountId == null || accountId.isEmpty) {
        setState(() {
          _error = 'No account found';
          _loading = false;
        });
        return;
      }
      final result = await _productRepo.getAllProductsByAccountId(accountId: accountId);
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

  Future<void> _submit() async {
    if (_selectedProductId == null) return;
    setState(() => _submitting = true);
    try {
      final accountId = await _storage.read(key: 'accountId') ?? await _storage.read(key: 'account_id');
      if (accountId == null || accountId.isEmpty) {
        throw Exception('No account found');
      }

      final product = _products.firstWhere((p) => p.id == _selectedProductId);

      final minT = double.tryParse(_minTempController.text) ?? 0;
      final maxT = double.tryParse(_maxTempController.text) ?? 0;

      final req = CareGuideRequest(
        careGuideId: '',
        accountId: accountId,
        productAssociated: _typeController.text.isNotEmpty ? _typeController.text : product.type,
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        title: '${product.name} Care Guide',
        summary: _commentsController.text,
        recommendedMinTemperature: minT,
        recommendedMaxTemperature: maxT,
        recommendedPlaceStorage: '',
        generalRecommendation: '',
        guideFileName: null,
        fileName: null,
        fileContentType: null,
        fileData: null,
      );

      await _careRepo.createCareGuide(request: req);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Care guide created')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _commentsController.dispose();
    _minTempController.dispose();
    _maxTempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color pageBg = const Color(0xFFF3E9E7);

    OutlineInputBorder border() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFFB1A6A6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(),
    );

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF471725)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Guide', style: TextStyle(color: Color(0xFF471725), fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
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
                    initialValue: _selectedProduct,
                    decoration: inputDecoration.copyWith(hintText: 'Select Product'),
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF471725)),
                    items: const [
                      DropdownMenuItem(value: 'Whiskey', child: Text('Whiskey')),
                      DropdownMenuItem(value: 'Wine', child: Text('Wine')),
                      DropdownMenuItem(value: 'Rum', child: Text('Rum')),
                    ],
                    onChanged: (v) => setState(() => _selectedProduct = v),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(_error!),
                  )
                else
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
                      value: _selectedProductId,
                      decoration: inputDecoration.copyWith(hintText: 'Select Product'),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF471725)),
                      isExpanded: true,
                      menuMaxHeight: 320,
                      items: _products
                          .map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.name),
                              ))
                          .toList(),
                      onChanged: _products.isEmpty ? null : (v) => setState(() => _selectedProductId = v),
                    ),
                  ),
                if (!_loading && _error == null && _products.isEmpty) ...[
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No products found. Please register a product first.',
                      style: TextStyle(color: Color(0xFF9E9E9E)),
                    ),
                  )
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _typeController,
                  decoration: inputDecoration.copyWith(hintText: 'Type'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _commentsController,
                  maxLines: 5,
                  decoration: inputDecoration.copyWith(hintText: 'Comments'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minTempController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(hintText: 'Min. Temperature'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _maxTempController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(hintText: 'Max. Temperature'),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedProductId == null || _submitting) ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A0A14),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(_submitting ? 'Adding...' : 'Add', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
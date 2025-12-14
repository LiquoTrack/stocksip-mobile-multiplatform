import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

class CareguideCreatePage extends StatefulWidget {
  final BuildContext parentContext;

  const CareguideCreatePage({super.key, required this.parentContext});

  @override
  State<CareguideCreatePage> createState() => _CareguideCreatePageState();
}

class _CareguideCreatePageState extends State<CareguideCreatePage> {
  final formKey = GlobalKey<FormState>();
  String? selectedProduct;
  List<ProductResponse> _products = const [];
  late final TextEditingController typeCtrl;
  late final TextEditingController commentsCtrl;
  late final TextEditingController minTempCtrl;
  late final TextEditingController maxTempCtrl;
  late final FocusNode typeFocus;

  @override
  void initState() {
    super.initState();
    typeCtrl = TextEditingController();
    commentsCtrl = TextEditingController();
    minTempCtrl = TextEditingController();
    maxTempCtrl = TextEditingController();
    typeFocus = FocusNode();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final repo = ProductRepositoryImpl(
        service: ProductService(client: AuthHttpClient()),
        tokenStorage: TokenStorage(),
      );
      final productsWithCount = await repo.getAllProductsByAccountId();
      if (!mounted) return;
      setState(() {
        _products = productsWithCount.products;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    typeCtrl.dispose();
    commentsCtrl.dispose();
    minTempCtrl.dispose();
    maxTempCtrl.dispose();
    typeFocus.dispose();
    super.dispose();
  }

  Future<void> _onCreatePressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final accountId = await TokenStorage().readAccountId() ?? '';
    if (accountId.isEmpty) return;

    final minT = int.tryParse(minTempCtrl.text.trim()) ?? 0;
    final maxT = int.tryParse(maxTempCtrl.text.trim()) ?? 0;

    final cg = CareGuide(
      id: '',
      accountId: accountId,
      typeOfLiquor: typeCtrl.text.trim(),
      productName: selectedProduct ?? '',
      title: typeCtrl.text.trim(),
      summary: commentsCtrl.text.trim(),
      recommendedMinTemperature: minT,
      recommendedMaxTemperature: maxT,
      createdAt: '',
      updatedAt: '',
    );

    try {
      widget.parentContext.read<CareguideBloc>().add(OnCareGuideCreated(careGuide: cg));
    } catch (_) {
      BlocProvider.of<CareguideBloc>(widget.parentContext).add(OnCareGuideCreated(careGuide: cg));
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textStyleLabel = const TextStyle(
      color: Color(0xFF2B000D),
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: SingleChildScrollView(
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
                  child: Form(
                    key: formKey,
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
                          'New Care Guide',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B000D),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Product', style: textStyleLabel),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            value: selectedProduct,
                            hint: const Text('Select Product'),
                            items: _products
                                .map((p) => DropdownMenuItem<String>(
                                      value: p.name,
                                      child: Text(p.name),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() => selectedProduct = v);
                              Future.delayed(Duration.zero, () {
                                FocusScope.of(context).requestFocus(typeFocus);
                              });
                            },
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Type', style: textStyleLabel),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: TextFormField(
                            controller: typeCtrl,
                            focusNode: typeFocus,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              hintText: 'Enter type',
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Comments', style: textStyleLabel),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: TextFormField(
                            controller: commentsCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              hintText: 'Enter comments',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Temperature Range', style: textStyleLabel),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE0D4D4)),
                                ),
                                child: TextFormField(
                                  controller: minTempCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    hintText: 'Min',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Required';
                                    return (int.tryParse(v.trim()) == null) ? 'Number' : null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE0D4D4)),
                                ),
                                child: TextFormField(
                                  controller: maxTempCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    hintText: 'Max',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Required';
                                    return (int.tryParse(v.trim()) == null) ? 'Number' : null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onCreatePressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C1F24),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('Create Guide', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';

class CareguideCreatePage extends StatelessWidget {
  final BuildContext parentContext;

  const CareguideCreatePage({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final textStyleLabel = const TextStyle(
      color: Color(0xFF2B000D),
      fontWeight: FontWeight.w600,
    );

    final formKey = GlobalKey<FormState>();
    String? selectedProduct;
    final typeCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();
    final minTempCtrl = TextEditingController();
    final maxTempCtrl = TextEditingController();

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
                          initialValue: selectedProduct,
                          hint: const Text('Select Product'),
                          items: const [
                            DropdownMenuItem(value: 'Wine', child: Text('Wine')),
                            DropdownMenuItem(value: 'Whisky', child: Text('Whisky')),
                            DropdownMenuItem(value: 'Soda', child: Text('Soda')),
                          ],
                          onChanged: (v) => setState(() => selectedProduct = v),
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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Enter type',
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
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
                                validator: (v) => (int.tryParse(v ?? '') == null) ? 'Number' : null,
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
                                validator: (v) => (int.tryParse(v ?? '') == null) ? 'Number' : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
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

                            parentContext.read<CareguideBloc>().add(OnCareGuideCreated(careGuide: cg));
                            if (context.mounted) Navigator.of(context).pop();
                          },
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
            ),
          ],
        ),
      ),
    );
  }
}

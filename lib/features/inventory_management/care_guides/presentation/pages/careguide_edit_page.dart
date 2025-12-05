import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';

class CareGuideEditPage extends StatelessWidget {
  final CareGuide careGuide;
  final BuildContext parentContext;

  const CareGuideEditPage({
    super.key,
    required this.careGuide,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    final textStyleLabel = const TextStyle(
      color: Color(0xFF2B000D),
      fontWeight: FontWeight.w600,
    );

    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: careGuide.title);
    final summaryCtrl = TextEditingController(text: careGuide.summary);
    final minTempCtrl = TextEditingController(text: careGuide.recommendedMinTemperature.toString());
    final maxTempCtrl = TextEditingController(text: careGuide.recommendedMaxTemperature.toString());
    final storagePlaceCtrl = TextEditingController();
    final generalRecCtrl = TextEditingController();

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
                        'Edit Care Guide',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B000D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Text('Title', style: textStyleLabel),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0D4D4)),
                        ),
                        child: TextFormField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Enter title',
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('Summary', style: textStyleLabel),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0D4D4)),
                        ),
                        child: TextFormField(
                          controller: summaryCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Enter summary',
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
                      const SizedBox(height: 16),

                      Text('Recommended Storage Place', style: textStyleLabel),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0D4D4)),
                        ),
                        child: TextFormField(
                          controller: storagePlaceCtrl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Enter storage place',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('General Recommendation', style: textStyleLabel),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0D4D4)),
                        ),
                        child: TextFormField(
                          controller: generalRecCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Enter general recommendation',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!(formKey.currentState?.validate() ?? false)) return;
                            
                            try {
                              final repository = CareguideRepositoryImpl(
                                service: CareguideService(client: AuthHttpClient()),
                              );

                              await repository.updateCareGuide(
                                careGuideId: careGuide.id,
                                careGuide: careGuide.copyWith(
                                  title: titleCtrl.text.trim(),
                                  summary: summaryCtrl.text.trim(),
                                  recommendedMinTemperature: int.tryParse(minTempCtrl.text.trim()) ?? 0,
                                  recommendedMaxTemperature: int.tryParse(maxTempCtrl.text.trim()) ?? 0,
                                ),
                                recommendedPlaceStorage: storagePlaceCtrl.text.trim().isNotEmpty 
                                    ? storagePlaceCtrl.text.trim() 
                                    : null,
                                generalRecommendation: generalRecCtrl.text.trim().isNotEmpty 
                                    ? generalRecCtrl.text.trim() 
                                    : null,
                              );

                              final accountId = await TokenStorage().readAccountId() ?? '';
                              if (accountId.isNotEmpty && context.mounted) {
                                parentContext.read<CareguideBloc>().add(
                                  GetCareGuidesByAccountIdEvent(accountId: accountId),
                                );
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Care guide updated successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error updating care guide: $e'),
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
                          child: const Text('Update Guide', style: TextStyle(fontSize: 16)),
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

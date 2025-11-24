import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_request.dart';

class CareGuideUpdate extends StatefulWidget {
  final CareguideResponse guide;
  const CareGuideUpdate({super.key, required this.guide});

  @override
  State<CareGuideUpdate> createState() => _CareGuideUpdateState();
}

class _CareGuideUpdateState extends State<CareGuideUpdate> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _commentsCtrl;
  late final TextEditingController _minTempCtrl;
  late final TextEditingController _maxTempCtrl;

  bool _saving = false;
  final _repo = CareguideRepositoryImpl(service: CareguideService());

  @override
  void initState() {
    super.initState();
    final g = widget.guide;
    _titleCtrl = TextEditingController(text: g.title);
    _typeCtrl = TextEditingController(text: g.productAssociated);
    _commentsCtrl = TextEditingController(text: g.summary);
    _minTempCtrl = TextEditingController(text: g.recommendedMinTemperature.toStringAsFixed(0));
    _maxTempCtrl = TextEditingController(text: g.recommendedMaxTemperature.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _typeCtrl.dispose();
    _commentsCtrl.dispose();
    _minTempCtrl.dispose();
    _maxTempCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final g = widget.guide;
      final minT = double.tryParse(_minTempCtrl.text) ?? g.recommendedMinTemperature;
      final maxT = double.tryParse(_maxTempCtrl.text) ?? g.recommendedMaxTemperature;

      final req = CareGuideRequest(
        careGuideId: g.careGuideId,
        accountId: g.accountId,
        productAssociated: _typeCtrl.text,
        productId: g.productId,
        productName: g.productName,
        imageUrl: g.imageUrl,
        title: _titleCtrl.text,
        summary: _commentsCtrl.text,
        recommendedMinTemperature: minT,
        recommendedMaxTemperature: maxT,
        recommendedPlaceStorage: g.recommendedPlaceStorage,
        generalRecommendation: g.generalRecommendation,
        guideFileName: g.guideFileName,
        fileName: null,
        fileContentType: null,
        fileData: null,
      );

      await _repo.updateCareGuide(careGuideId: g.careGuideId, request: req);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide updated')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.guide;
    final Color pageBg = const Color(0xFFF6ECE4);
    final Color accent = const Color(0xFF7A1D2A);

    InputDecoration deco(String hint) => InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF6EDE3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: accent.withOpacity(0.4)),
          ),
        );

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(g.title, style: TextStyle(color: accent, fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.delete_outline, color: Colors.black.withOpacity(0.2)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9DAD0),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: g.imageUrl.isNotEmpty
                    ? Image.network(g.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.local_cafe, color: accent, size: 48))
                    : Icon(Icons.local_cafe, color: accent, size: 48),
              ),
              const SizedBox(height: 16),
              TextField(controller: _titleCtrl, decoration: deco('Title')),
              const SizedBox(height: 14),
              TextField(controller: _typeCtrl, decoration: deco('Type')),
              const SizedBox(height: 14),
              TextField(controller: _commentsCtrl, decoration: deco('Comments')),
              const SizedBox(height: 14),
              TextField(controller: _minTempCtrl, keyboardType: TextInputType.number, decoration: deco('Min')),
              const SizedBox(height: 14),
              TextField(controller: _maxTempCtrl, keyboardType: TextInputType.number, decoration: deco('Max')),
              const SizedBox(height: 26),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A0A14),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text(_saving ? 'Saving...' : 'Save', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
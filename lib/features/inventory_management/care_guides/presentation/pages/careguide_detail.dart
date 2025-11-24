import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';

class CareGuideDetail extends StatelessWidget {
  final CareguideResponse guide;

  const CareGuideDetail({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final Color pageBg = const Color(0xFFF3E9E7);
    final Color cardBg = Colors.white;
    final Color iconBg = const Color(0xFFEAD7C7);
    final Color accent = const Color(0xFF471725);

    Widget item(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF413A3A))),
            const SizedBox(height: 6),
            Text(value.isNotEmpty ? value : '-', style: const TextStyle(color: Color(0xFF8D8484))),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF471725)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Guide Detail', style: TextStyle(color: Color(0xFF471725), fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.local_cafe, size: 40, color: accent),
                ),
                const SizedBox(height: 16),
                item('Product Name', guide.productName),
                item('Type', guide.title),
                item('Comments', guide.summary),
                item('Min. Temperature', '${guide.recommendedMinTemperature.toStringAsFixed(1)}° C'),
                item('Max. Temperature', '${guide.recommendedMaxTemperature.toStringAsFixed(1)}° C'),
                const Spacer(),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9C2C3A),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
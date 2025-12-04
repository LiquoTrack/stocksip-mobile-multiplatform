import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';

class CareGuideWrapper {
  final int count;
  final List<CareGuide> careGuides;

  const CareGuideWrapper({required this.count, required this.careGuides});

  CareGuideWrapper copyWith({
    int? count,
    List<CareGuide>? careGuides,
  }) {
    return CareGuideWrapper(
      count: count ?? this.count,
      careGuides: careGuides ?? this.careGuides,
    );
  }
}
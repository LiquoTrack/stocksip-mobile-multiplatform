import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';

abstract class CareGuideRepository {
  Future<CareGuide> getById({required String careGuideId});

  Future<List<CareGuide>> getAllCareGuideById({required String accountId});

  Future<CareGuide> createCareGuide({required CareGuide careGuide});

  Future<CareGuide> updateCareGuide({required String careGuideId, required CareGuide careGuide, String? recommendedPlaceStorage, String? generalRecommendation});

  Future<void> deleteCareGuide({required String careGuideId});

  Future<List<CareGuide>> getCareGuideByProductType({required String accountId, required String productType});

  Future<void> unassignCareGuide({required String careGuideId});

  Future<void> assignCareGuide({required String careGuideId, required String productId});
} 
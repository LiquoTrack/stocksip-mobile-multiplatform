import 'package:stocksip/features/inventory_management/care_guides/data/remote/mappers/careguide_mapper.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_request_dto.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/repositories/careguide_repository.dart';

class CareguideRepositoryImpl implements CareGuideRepository {
  final CareguideService service;

  const CareguideRepositoryImpl({required this.service});

  @override
  Future<CareGuide> getById({required String careGuideId}) async {
    final dto = await service.getById(careGuideId);
    return CareguideMapper.toDomain(dto);
  }

  @override
  Future<List<CareGuide>> getAllCareGuideById({required String accountId}) async {
    final wrapper = await service.getCareGuidesByAccountId(accountId);
    return CareguideMapper.toDomainWrapper(wrapper).careGuides;
  }

  @override
  Future<CareGuide> createCareGuide({required CareGuide careGuide}) async {
    final req = CareguideRequestDto(
      typeOfLiquor: careGuide.typeOfLiquor,
      productName: careGuide.productName,
      title: careGuide.title,
      summary: careGuide.summary,
      recommendedMinTemperature: careGuide.recommendedMinTemperature,
      recommendedMaxTemperature: careGuide.recommendedMaxTemperature,
    );
    final dto = await service.createCareGuide(careGuide.accountId, req);
    return CareguideMapper.toDomain(dto);
  }

  @override
  Future<CareGuide> updateCareGuide({required String careGuideId, required CareGuide careGuide, String? recommendedPlaceStorage, String? generalRecommendation}) async {
    final requestBody = {
      'careGuideId': careGuideId,
      'title': careGuide.title,
      'summary': careGuide.summary,
      'recommendedMinTemperature': careGuide.recommendedMinTemperature,
      'recommendedMaxTemperature': careGuide.recommendedMaxTemperature,
      'recommendedPlaceStorage': recommendedPlaceStorage ?? '',
      'generalRecommendation': generalRecommendation ?? '',
    };
    
    final dto = await service.updateCareGuideWithBody(careGuideId, requestBody);
    return CareguideMapper.toDomain(dto);
  }

  @override
  Future<void> deleteCareGuide({required String careGuideId}) async {
    await service.deleteCareGuide(careGuideId);
  }

  @override
  Future<List<CareGuide>> getCareGuideByProductType({required String accountId, required String productType}) async {
    final list = await service.getCareGuideByProductType(accountId, productType);
    return CareguideMapper.listToDomain(list);
  }

  @override
  Future<void> unassignCareGuide({required String careGuideId}) async {
    await service.unassignCareGuide(careGuideId);
  }

  @override
  Future<void> assignCareGuide({required String careGuideId, required String productId}) async {
    await service.assignCareGuide(careGuideId, productId);
  }
}

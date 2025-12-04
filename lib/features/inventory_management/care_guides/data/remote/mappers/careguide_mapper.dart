import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_dto.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/models/careguide_wrapper_dto.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide_wrapper.dart';

class CareguideMapper {

  static CareGuide toDomain(CareguideDto dto) {
    return CareGuide(
      id: dto.careGuideId,
      accountId: dto.accountId,
      typeOfLiquor: dto.typeOfLiquor,
      productName: dto.productName,
      title: dto.title,
      summary: dto.summary,
      recommendedMinTemperature: dto.recommendedMinTemperature,
      recommendedMaxTemperature: dto.recommendedMaxTemperature,
      createdAt: '',
      updatedAt: '',
    );
  }

  static List<CareGuide> listToDomain(List<CareguideDto> list) => list.map(toDomain).toList();

  static CareGuideWrapper toDomainWrapper(CareguideWrapperDto dto) {
    return CareGuideWrapper(
      count: dto.count,
      careGuides: listToDomain(dto.careGuides),
    );
  }
}
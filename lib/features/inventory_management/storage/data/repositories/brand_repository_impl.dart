import 'package:stocksip/features/inventory_management/storage/data/remote/brand_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/brand_repository.dart';

/// Implementation of the [BrandRepository] interface for managing brands.
class BrandRepositoryImpl implements BrandRepository {

  final BrandService brandService;

  /// Constructor for [BrandRepositoryImpl].
  const BrandRepositoryImpl({required this.brandService});

  /// Retrieves all brand names from the service.
  @override
  Future<List<String>> getAllBrandNames() async {
    try {
      final brands = await brandService.getAllBrands();
      return brands.map((brand) => brand.name).toList();
    } catch (e) {
      throw Exception('Fetching brand names failed: $e');
    }
  }

}
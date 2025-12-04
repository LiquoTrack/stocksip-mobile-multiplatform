import 'package:stocksip/features/inventory_management/storage/data/remote/product_type_service.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_type_repository.dart';

/// Implementation of the [ProductTypeRepository] interface for managing product types.
class ProductTypeRepositoryImpl implements ProductTypeRepository {

  final ProductTypeService productTypeService;

  /// Constructor for [ProductTypeRepositoryImpl].
  const ProductTypeRepositoryImpl({required this.productTypeService});

  /// Retrieves all product type names from the service.
  @override
  Future<List<String>> getAllProductTypeNames() async {
    try {
      final productTypes = await productTypeService.getAllProductTypes();
      return productTypes.map((type) => type.name).toList();
    } catch (e) {
      throw Exception('Fetching product type names failed: $e');
    }
  }

}
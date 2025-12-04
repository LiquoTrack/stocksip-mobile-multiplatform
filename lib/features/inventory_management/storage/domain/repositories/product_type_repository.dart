/// Repository interface for managing product types in the inventory management system.
abstract class ProductTypeRepository {

  /// Retrieves all product types from the repository.
  Future<String> getAllProductTypeNames();
}
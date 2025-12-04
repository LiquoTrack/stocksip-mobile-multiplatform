/// Repository interface for managing brands in the inventory management system.
abstract class BrandRepository {

  /// Retrieves all brands from the repository.
  Future<List<String>> getAllBrandNames();
}
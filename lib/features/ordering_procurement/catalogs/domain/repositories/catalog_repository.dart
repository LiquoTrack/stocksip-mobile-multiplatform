import '../models/catalog.dart';
import '../../data/remote/models/mappers.dart';

/// Abstract repository for catalog-related operations
abstract class CatalogRepository {
  /// Fetches all catalogs by account ID
  Future<List<Catalog>> getCatalogsByAccountId(String accountId);

  /// Fetches account with associated catalogs
  Future<SupplierInfo> getAccountWithCatalogs(String accountId);

  /// Fetches all published catalogs
  Future<List<Catalog>> getPublishedCatalogs();

  /// Fetches all catalogs
  Future<List<Catalog>> getAllCatalogs();

  /// Fetches a single catalog by ID
  Future<Catalog> getCatalogById(String catalogId);

  /// Creates a new catalog
  Future<Catalog> createCatalog({
    required String accountId,
    required String name,
    required String description,
    required String contactEmail,
  });

  /// Updates an existing catalog
  Future<Catalog> updateCatalog({
    required String catalogId,
    required String name,
    required String description,
    required String contactEmail,
  });

  /// Adds an item to a catalog
  Future<Catalog> addCatalogItem({
    required String catalogId,
    required String productId,
    required String warehouseId,
    required int stock,
  });

  /// Removes an item from a catalog
  Future<Catalog> removeCatalogItem({
    required String catalogId,
    required String productId,
  });

  /// Publishes a catalog
  Future<void> publishCatalog(String catalogId);

  /// Unpublishes a catalog
  Future<void> unpublishCatalog(String catalogId);
}


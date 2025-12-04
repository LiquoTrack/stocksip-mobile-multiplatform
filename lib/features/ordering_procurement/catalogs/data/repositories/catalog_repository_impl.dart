import '../../domain/models/catalog.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../services/remote/catalog_service.dart';
import '../remote/models/mappers.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogService _catalogService;

  CatalogRepositoryImpl({required CatalogService catalogService})
      : _catalogService = catalogService;

  @override
  Future<List<Catalog>> getCatalogsByAccountId(String accountId) async {
    return await _catalogService.getCatalogsByAccountId(accountId);
  }

  @override
  Future<SupplierInfo> getAccountWithCatalogs(String accountId) async {
    return await _catalogService.getAccountWithCatalogs(accountId);
  }

  @override
  Future<List<Catalog>> getPublishedCatalogs() async {
    return await _catalogService.getPublishedCatalogs();
  }

  @override
  Future<List<Catalog>> getAllCatalogs() async {
    return await _catalogService.getAllCatalogs();
  }

  @override
  Future<Catalog> getCatalogById(String catalogId) async {
    return await _catalogService.getCatalogById(catalogId);
  }

  @override
  Future<Catalog> createCatalog({
    required String accountId,
    required String name,
    required String description,
    required String contactEmail,
  }) async {
    return await _catalogService.createCatalog(
      accountId: accountId,
      name: name,
      description: description,
      contactEmail: contactEmail,
    );
  }

  @override
  Future<Catalog> updateCatalog({
    required String catalogId,
    required String name,
    required String description,
    required String contactEmail,
  }) async {
    return await _catalogService.updateCatalog(
      catalogId: catalogId,
      name: name,
      description: description,
      contactEmail: contactEmail,
    );
  }

  @override
  Future<Catalog> addCatalogItem({
    required String catalogId,
    required String productId,
    required String warehouseId,
    required int stock,
  }) async {
    return await _catalogService.addCatalogItem(
      catalogId: catalogId,
      productId: productId,
      warehouseId: warehouseId,
      stock: stock,
    );
  }

  @override
  Future<Catalog> removeCatalogItem({
    required String catalogId,
    required String productId,
  }) async {
    return await _catalogService.removeCatalogItem(
      catalogId: catalogId,
      productId: productId,
    );
  }

  @override
  Future<void> publishCatalog(String catalogId) async {
    await _catalogService.publishCatalog(catalogId);
  }

  @override
  Future<void> unpublishCatalog(String catalogId) async {
    await _catalogService.unpublishCatalog(catalogId);
  }
}

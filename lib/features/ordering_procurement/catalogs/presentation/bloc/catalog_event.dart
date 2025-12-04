/// Base class for catalog events
abstract class CatalogEvent {
  const CatalogEvent();
}

/// Event to load catalogs by account ID
class LoadCatalogsByAccountId extends CatalogEvent {
  final String accountId;

  const LoadCatalogsByAccountId({required this.accountId});
}

/// Event to load account with associated catalogs
class LoadAccountWithCatalogs extends CatalogEvent {
  final String accountId;

  const LoadAccountWithCatalogs({required this.accountId});
}

/// Event to load published catalogs
class LoadPublishedCatalogs extends CatalogEvent {
  const LoadPublishedCatalogs();
}

/// Event to load all catalogs
class LoadAllCatalogs extends CatalogEvent {
  const LoadAllCatalogs();
}

/// Event to load a single catalog by ID
class LoadCatalogById extends CatalogEvent {
  final String catalogId;

  const LoadCatalogById({required this.catalogId});
}

/// Event to create a new catalog
class CreateCatalog extends CatalogEvent {
  final String accountId;
  final String name;
  final String description;
  final String contactEmail;

  const CreateCatalog({
    required this.accountId,
    required this.name,
    required this.description,
    required this.contactEmail,
  });
}

/// Event to update an existing catalog
class UpdateCatalog extends CatalogEvent {
  final String catalogId;
  final String name;
  final String description;
  final String contactEmail;

  const UpdateCatalog({
    required this.catalogId,
    required this.name,
    required this.description,
    required this.contactEmail,
  });
}

/// Event to add an item to a catalog
class AddCatalogItem extends CatalogEvent {
  final String catalogId;
  final String productId;
  final String warehouseId;
  final int stock;

  const AddCatalogItem({
    required this.catalogId,
    required this.productId,
    required this.warehouseId,
    required this.stock,
  });
}

/// Event to remove an item from a catalog
class RemoveCatalogItem extends CatalogEvent {
  final String catalogId;
  final String productId;

  const RemoveCatalogItem({
    required this.catalogId,
    required this.productId,
  });
}

/// Event to publish a catalog
class PublishCatalog extends CatalogEvent {
  final String catalogId;

  const PublishCatalog({required this.catalogId});
}

/// Event to unpublish a catalog
class UnpublishCatalog extends CatalogEvent {
  final String catalogId;

  const UnpublishCatalog({required this.catalogId});
}

/// Event to toggle edit mode
class ToggleEditMode extends CatalogEvent {
  final bool isEditMode;

  const ToggleEditMode({required this.isEditMode});
}

/// Event to clear message
class ClearMessage extends CatalogEvent {
  const ClearMessage();
}

/// Represents events related to storage operations in the inventory management feature.
abstract class StorageEvent {
  const StorageEvent();
}

/// Event to fetch products by a specific account ID.
/// Requires the account ID as a parameter.
/// The account ID is taken from the tokenManager service.
class GetProductsByAccountIdEvent extends StorageEvent {

  const GetProductsByAccountIdEvent();
}
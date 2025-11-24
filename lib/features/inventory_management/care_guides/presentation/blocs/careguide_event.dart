/// Represents events related to careguide operations in the inventory management feature.
abstract class CareguideEvent {
  const CareguideEvent();
}

/// Event to fetch care guides by a specific account ID.
class GetCareGuidesByAccountIdEvent extends CareguideEvent {
  final String accountId;
  const GetCareGuidesByAccountIdEvent({required this.accountId});
}

/// Event to fetch care guides by product type within an account.
class GetCareGuidesByProductTypeEvent extends CareguideEvent {
  final String accountId;
  final String productType;
  const GetCareGuidesByProductTypeEvent({required this.accountId, required this.productType});
}
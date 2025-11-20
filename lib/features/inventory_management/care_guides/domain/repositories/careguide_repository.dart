import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_request.dart';

/// Abstract repository interface for managing care guides in the inventory management system.
/// Defines methods for fetching, registering, updating, and deleting care guides.
abstract class CareGuideRepository {

  /// Fetches a care guide by its [careGuideId].
  /// Returns a [CareguideResponse] instance representing the care guide details.
  Future<CareguideResponse> getById({required String careGuideId});

  /// Fetches all care guides associated with the given [accountId].
  /// Returns a [List<CareguideResponse>] instance containing the care guides and their count information.
  Future<List<CareguideResponse>> getAllCareGuideBytId({required String accountId});

  /// Registers a new care guide for the given [accountId] using the provided [request] data.
  /// Returns a [CareguideResponse] instance representing the newly created care guide.
  Future<CareguideResponse> createCareGuide({required CareGuideRequest request});

  /// Updates an existing care guide identified by [careGuideId] using the provided [request] data.
  /// Returns a [CareguideResponse] instance representing the updated care guide.
  Future<CareguideResponse> updateCareGuide({required String careGuideId, required CareGuideRequest request});

  /// Deletes a care guide identified by [careGuideId].
  /// Returns a [Future] that completes when the deletion is done.
  Future<void> deleteCareGuide({required String careGuideId});

  /// Fetches all care guides associated with the given [accountId] and [productType].
  /// Returns a [List<CareguideResponse>] instance containing the care guides and their count information.
  Future<List<CareguideResponse>> getCareGuideByProductType({required String accountId, required String productType});

  /// Unassigns a care guide identified by [careGuideId].
  /// Returns a [Future] that completes when the unassignment is done.
  Future<void> unassignCareGuide({required String careGuideId});

  /// Assigns a care guide identified by [careGuideId] to a product identified by [productId].
  /// Returns a [Future] that completes when the assignment is done.
  Future<void> assignCareGuide({required String careGuideId, required String productId});
}
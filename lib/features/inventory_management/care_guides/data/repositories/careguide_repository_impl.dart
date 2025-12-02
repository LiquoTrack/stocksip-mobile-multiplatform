import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/repositories/careguide_repository.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_request.dart';

/// Implementation of the CareGuideRepository interface for managing care guides
/// in the inventory management system. This class interacts with the
/// CareguideService to perform CRUD operations on care guides.
class CareguideRepositoryImpl implements CareGuideRepository {
  // The service used to perform remote operations related to care guides.
  final CareguideService service;

  // Constructor that accepts a CareguideService instance.
  const CareguideRepositoryImpl({required this.service});

  /// Fetches a care guide by its [careGuideId].
  /// Returns a [CareguideResponse] instance representing the care guide details.
  @override
  Future<CareguideResponse> getById({required String careGuideId}) {
    return service.getById(careGuideId: careGuideId);
  }

  /// Fetches all care guides associated with the given [accountId].
  /// Returns a list of [CareguideResponse] instances upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<List<CareguideResponse>> getAllCareGuideBytId({required String accountId}) async {
    return service.getAllCareGuideByAccountId(accountId: accountId);
  }

  /// Registers a new care guide using the provided [request] details for the given [accountId].
  /// Returns a [CareguideResponse] instance upon successful registration.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<CareguideResponse> createCareGuide({required CareGuideRequest request}) {
    return service.createCareGuide(request: request);
  }

  /// Updates an existing care guide identified by [careGuideId] using the provided [request] data.
  /// Returns a [CareguideResponse] instance representing the updated care guide.
  @override
  Future<CareguideResponse> updateCareGuide({required String careGuideId, required CareGuideRequest request}) {
    return service.updateCareGuide(careGuideId: careGuideId, request: request);
  }

  /// Deletes a care guide by its [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<void> deleteCareGuide({required String careGuideId}) {
    return service.deleteCareGuide(careGuideId: careGuideId);
  }

  /// Fetches care guides associated with the given [accountId] and [productType].
  /// Returns a list of [CareguideResponse] instances upon successful retrieval.
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<List<CareguideResponse>> getCareGuideByProductType({required String accountId, required String productType}) {
    return service.getCareGuideByProductType(accountId: accountId, productType: productType);
  }

  /// Unassigns a care guide from a product identified by [careGuideId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<void> unassignCareGuide({required String careGuideId}) {
    return service.unassignCareGuide(careGuideId: careGuideId);
  }

  /// Assigns a care guide to a product identified by [careGuideId] and [productId].
  /// Throws an [HttpException] for non-200 HTTP responses,
  /// a [SocketException] for network issues,
  /// and a [FormatException] for JSON parsing errors.
  @override
  Future<void> assignCareGuide({required String careGuideId, required String productId}) {
    return service.assignCareGuide(careGuideId: careGuideId, productId: productId);
  }
}

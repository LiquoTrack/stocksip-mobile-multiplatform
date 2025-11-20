import 'dart:typed_data';

/// Represents a request to create or update a care guide in the inventory system.
/// Contains necessary details about the care guide.
/// Includes an image file for the care guide.
class CareGuideRequest {
  final String careGuideId;
  final String accountId;
  final String productAssociated;
  final String productId;
  final String productName;
  final String imageUrl;
  final String title;
  final String summary;
  final double recommendedMinTemperature;
  final double recommendedMaxTemperature;
  final String recommendedPlaceStorage;
  final String generalRecommendation;
  final String? guideFileName;
  final String? fileName;
  final String? fileContentType;
  final Uint8List? fileData;

  /// Constructs a CareGuideRequest instance with the given parameters.
  const CareGuideRequest({
    required this.careGuideId,
    required this.accountId,
    required this.productAssociated,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.title,
    required this.summary,
    required this.recommendedMinTemperature,
    required this.recommendedMaxTemperature,
    required this.recommendedPlaceStorage,
    required this.generalRecommendation,
    required this.guideFileName,
    required this.fileName,
    required this.fileContentType,
    required this.fileData,
  });

  /// Converts the CareGuideRequest instance to a JSON map.
  Map<String, String> toFields() {
    return {
      'careGuideId': careGuideId,
      'accountId': accountId,
      'productAssociated': productAssociated,
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'title': title,
      'summary': summary,
      'recommendedMinTemperature': recommendedMinTemperature.toString(),
      'recommendedMaxTemperature': recommendedMaxTemperature.toString(),
      'recommendedPlaceStorage': recommendedPlaceStorage,
      'generalRecommendation': generalRecommendation,
      'guideFileName': guideFileName ?? '',
      'fileName': fileName ?? '',
      'fileContentType': fileContentType ?? '',
    };
  }
}
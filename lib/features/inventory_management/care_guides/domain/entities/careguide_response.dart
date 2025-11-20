/// Represents a care guide response in the inventory management system.
/// Contains details about the care guide.
/// Includes a factory constructor to create an instance from JSON data.
class CareguideResponse {
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
  final String guideFileName;
  final String fileName;
  final String fileContentType;

  // Constructor for creating a CareguideResponse instance.
  const CareguideResponse({
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
  });

  /// Creates a [CareguideResponse] instance from a JSON map.
  factory CareguideResponse.fromJson(Map<String, dynamic> json) {
    return CareguideResponse(
      careGuideId: (json['careGuideId'] as String?) ?? '',
      accountId: (json['accountId'] as String?) ?? '',
      productAssociated: (json['productAssociated'] as String?) ?? '',
      productId: (json['productId'] as String?) ?? '',
      productName: (json['productName'] as String?) ?? '',
      imageUrl: (json['imageUrl'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      summary: (json['summary'] as String?) ?? '',
      recommendedMinTemperature: (json['recommendedMinTemperature'] as num?)?.toDouble() ?? 0.0,
      recommendedMaxTemperature: (json['recommendedMaxTemperature'] as num?)?.toDouble() ?? 0.0,
      recommendedPlaceStorage: (json['recommendedPlaceStorage'] as String?) ?? '',
      generalRecommendation: (json['generalRecommendation'] as String?) ?? '',
      guideFileName: (json['guideFileName'] as String?) ?? '',
      fileName: (json['fileName'] as String?) ?? '',
      fileContentType: (json['fileContentType'] as String?) ?? '',
    );
  }
}
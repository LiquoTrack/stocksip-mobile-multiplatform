import 'dart:typed_data';

class CareGuideResponse {
  final String careGuideId;
  final String accountId;
  final String? productAssociated;
  final String productId;
  final String? productName;
  final String? imageUrl;
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

  CareGuideResponse({
    required this.careGuideId,
    required this.accountId,
    this.productAssociated,
    required this.productId,
    this.productName,
    this.imageUrl,
    required this.title,
    required this.summary,
    required this.recommendedMinTemperature,
    required this.recommendedMaxTemperature,
    required this.recommendedPlaceStorage,
    required this.generalRecommendation,
    this.guideFileName,
    this.fileName,
    this.fileContentType,
    this.fileData,
  });

  factory CareGuideResponse.fromJson(Map<String, dynamic> json) {
    return CareGuideResponse(
      careGuideId: json['careGuideId'],
      accountId: json['accountId'],
      productAssociated: json['productAssociated'],
      productId: json['productId'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      summary: json['summary'],
      recommendedMinTemperature: json['recommendedMinTemperature'],
      recommendedMaxTemperature: json['recommendedMaxTemperature'],
      recommendedPlaceStorage: json['recommendedPlaceStorage'],
      generalRecommendation: json['generalRecommendation'],
      guideFileName: json['guideFileName'],
      fileName: json['fileName'],
      fileContentType: json['fileContentType'],
      fileData: json['fileData'],
    );
  }
}
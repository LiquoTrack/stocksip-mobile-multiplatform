class CareguideDto {
  final String careGuideId;
  final String accountId;
  final String productId;
  final String title;
  final String summary;
  final int recommendedMinTemperature;
  final int recommendedMaxTemperature;
  final String? recommendedPlaceStorage;
  final String? generalRecommendation;
  final String typeOfLiquor;
  final String productName;
  final String imageUrl;

  const CareguideDto({
    required this.careGuideId,
    required this.accountId,
    required this.productId,
    required this.title,
    required this.summary,
    required this.recommendedMinTemperature,
    required this.recommendedMaxTemperature,
    this.recommendedPlaceStorage,
    this.generalRecommendation,
    required this.typeOfLiquor,
    required this.productName,
    required this.imageUrl,
  });

  factory CareguideDto.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    return CareguideDto(
      careGuideId: (json['careGuideId'] ?? json['id'] ?? '') as String,
      accountId: (json['accountId'] ?? '') as String,
      productId: (json['productId'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      summary: (json['summary'] ?? '') as String,
      recommendedMinTemperature: toInt(json['recommendedMinTemperature'] ?? json['minTemperature']),
      recommendedMaxTemperature: toInt(json['recommendedMaxTemperature'] ?? json['maxTemperature']),
      recommendedPlaceStorage: json['recommendedPlaceStorage']?.toString(),
      generalRecommendation: json['generalRecommendation']?.toString(),
      typeOfLiquor: (json['typeOfLiquor'] ?? json['productType'] ?? '') as String,
      productName: (json['productName'] ?? '') as String,
      imageUrl: (json['imageUrl'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'careGuideId': careGuideId,
        'accountId': accountId,
        'productId': productId,
        'title': title,
        'summary': summary,
        'recommendedMinTemperature': recommendedMinTemperature,
        'recommendedMaxTemperature': recommendedMaxTemperature,
        'recommendedPlaceStorage': recommendedPlaceStorage,
        'generalRecommendation': generalRecommendation,
        'typeOfLiquor': typeOfLiquor,
        'productName': productName,
        'imageUrl': imageUrl,
      };
}
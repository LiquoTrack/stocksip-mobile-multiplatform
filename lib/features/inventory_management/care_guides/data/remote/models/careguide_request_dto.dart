class CareguideRequestDto {
  final String typeOfLiquor;
  final String productName;
  final String title;
  final String summary;
  final int recommendedMinTemperature;
  final int recommendedMaxTemperature;
  final String? recommendedPlaceStorage;
  final String? generalRecommendation;

  const CareguideRequestDto({
    required this.typeOfLiquor,
    required this.productName,
    required this.title,
    required this.summary,
    required this.recommendedMinTemperature,
    required this.recommendedMaxTemperature,
    this.recommendedPlaceStorage,
    this.generalRecommendation,
  });

  Map<String, dynamic> toJson() => {
        'typeOfLiquor': typeOfLiquor,
        'productName': productName,
        'title': title,
        'summary': summary,
        'recommendedMinTemperature': recommendedMinTemperature,
        'recommendedMaxTemperature': recommendedMaxTemperature,
        if (recommendedPlaceStorage != null)
          'recommendedPlaceStorage': recommendedPlaceStorage,
        if (generalRecommendation != null)
          'generalRecommendation': generalRecommendation,
      };
}

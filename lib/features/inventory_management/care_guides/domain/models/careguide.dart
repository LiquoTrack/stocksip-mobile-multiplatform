class CareGuide {
  final String id;
  final String accountId;
  final String typeOfLiquor;
  final String productName;
  final String title;
  final String summary;
  final int recommendedMinTemperature;
  final int recommendedMaxTemperature;
  final String createdAt;
  final String updatedAt;

  const CareGuide({
    required this.id,
    required this.accountId,
    required this.typeOfLiquor,
    required this.productName,
    required this.title,
    required this.summary,
    required this.recommendedMinTemperature,
    required this.recommendedMaxTemperature,
    required this.createdAt,
    required this.updatedAt,
  });

  CareGuide copyWith({
    String? id,
    String? accountId,
    String? typeOfLiquor,
    String? productName,
    String? title,
    String? summary,
    int? recommendedMinTemperature,
    int? recommendedMaxTemperature,
    String? createdAt,
    String? updatedAt,
  }) {
    return CareGuide(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      typeOfLiquor: typeOfLiquor ?? this.typeOfLiquor,
      productName: productName ?? this.productName,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      recommendedMinTemperature: recommendedMinTemperature ?? this.recommendedMinTemperature,
      recommendedMaxTemperature: recommendedMaxTemperature ?? this.recommendedMaxTemperature,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CareGuide.fromJson(Map<String, dynamic> json) {
    int parseToInt(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return CareGuide(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      accountId: (json['accountId'] ?? '') as String,
      typeOfLiquor: (json['typeOfLiquor'] ?? json['productType'] ?? '') as String,
      productName: (json['productName'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      summary: (json['summary'] ?? '') as String,
      recommendedMinTemperature: parseToInt(json['recommendedMinTemperature'] ?? json['minTemperature']),
      recommendedMaxTemperature: parseToInt(json['recommendedMaxTemperature'] ?? json['maxTemperature']),
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }
}
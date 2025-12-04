class BusinessInfoDto {
  final String businessName;
  final String businessEmail;
  final String ruc;

  BusinessInfoDto({
    required this.businessName,
    required this.businessEmail,
    required this.ruc,
  });

  factory BusinessInfoDto.fromJson(Map<String, dynamic> json) {
    return BusinessInfoDto(
      businessName: json['businessName'] as String,
      businessEmail: json['businessEmail'] as String,
      ruc: json['ruc'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessEmail': businessEmail,
      'ruc': ruc,
    };
  }
}

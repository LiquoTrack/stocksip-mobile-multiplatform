class Business {
  final String businessName;

  const Business({
    required this.businessName,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['businessName'],
    );
  }
}
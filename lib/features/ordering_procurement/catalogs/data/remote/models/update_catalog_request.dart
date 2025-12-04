class UpdateCatalogRequest {
  final String name;
  final String description;
  final String contactEmail;

  UpdateCatalogRequest({
    required this.name,
    required this.description,
    required this.contactEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'contactEmail': contactEmail,
    };
  }
}

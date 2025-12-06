class CreateCatalogRequest {
  final String name;
  final String description;
  final String contactEmail;

  CreateCatalogRequest({
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

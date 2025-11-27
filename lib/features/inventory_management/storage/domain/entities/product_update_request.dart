import 'dart:io';

import 'package:http/http.dart' as http;

/// Represents a request to update a product in the inventory system.
/// Contains updatable details about the product.
/// Includes an image file for the product.
class ProductUpdateRequest {
  final String name;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File image;

  /// Constructs a ProductUpdateRequest instance with the given parameters.
  const ProductUpdateRequest({
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    required this.image,
  });

  /// Converts the ProductUpdateRequest instance to a fields map.
  Map<String, String> toFields() {
    return {
      'name': name,
      'unitPrice': unitPrice.toString(),
      'code': code,
      'minimumStock': minimumStock.toString(),
      'content': content.toString(),
      // Note: The image file is not included in the JSON representation.
    };
  }

  /// Converts the image file to a list of multipart files for HTTP requests.
  Future<List<http.MultipartFile>> toFiles() async {
    return [
      await http.MultipartFile.fromPath(
        'Image',
        image.path,
      ),
    ];
  }
}
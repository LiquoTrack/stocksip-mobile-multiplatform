import 'dart:io';

import 'package:http/http.dart' as http;

/// Represents a request to create or update a product in the inventory system.
/// Contains necessary details about the product.
/// Includes an image file for the product.
class ProductRequest {
  final String name;
  final String type;
  final String brand;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File image;
  final String? supplierId = "string";

  /// Constructs a ProductRequest instance with the given parameters.
  const ProductRequest({
    required this.name,
    required this.type,
    required this.brand,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    required this.image,
  });

  /// Converts the ProductRequest instance to a JSON map.
  Map<String, String> toFields() {
    return {
      'name': name,
      'type': type,
      'brand': brand,
      'unitPrice': unitPrice.toString(),
      'code': code,
      'minimumStock': minimumStock.toString(),
      'content': content.toString(),
      'supplierId': supplierId ?? 'string',
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
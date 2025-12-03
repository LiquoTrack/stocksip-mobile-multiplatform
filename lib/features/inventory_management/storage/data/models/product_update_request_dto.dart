import 'dart:io';

class ProductUpdateRequestDto {
  final String name;
  final double unitPrice;
  final String code;
  final int minimumStock;
  final double content;
  final File image;

  const ProductUpdateRequestDto({
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.minimumStock,
    required this.content,
    required this.image,
  });

  
}
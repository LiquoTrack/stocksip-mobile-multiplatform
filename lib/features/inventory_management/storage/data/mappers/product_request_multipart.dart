import 'package:http/http.dart' as http;
import 'package:stocksip/features/inventory_management/storage/data/models/product_request_dto.dart';

/// Extension to convert [ProductRequestDto] to a multipart HTTP request.
extension ProductRequestMultipart on ProductRequestDto {
  Future<http.MultipartRequest> toMultipart(String url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['type'] = type;
    request.fields['brand'] = brand;
    request.fields['unitPrice'] = unitPrice.toString();
    request.fields['moneyCode'] = code;
    request.fields['minimumStock'] = minimumStock.toString();
    request.fields['content'] = content.toString();
    request.fields['supplierId'] = supplierId ?? 'string';

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );
    }

    return request;
  }
}
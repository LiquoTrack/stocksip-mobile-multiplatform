import 'package:http/http.dart' as http;
import 'package:stocksip/features/inventory_management/storage/data/models/product_update_request_dto.dart';

/// Extension to convert [ProductUpdateRequestDto] to a multipart HTTP request.
extension ProductUpdateRequestMultipart on ProductUpdateRequestDto {
  Future<http.MultipartRequest> toMultipart(String url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url)); 

    request.fields['name'] = name;
    request.fields['unitPrice'] = unitPrice.toString();
    request.fields['moneyCode'] = code;
    request.fields['minimumStock'] = minimumStock.toString();
    request.fields['content'] = content.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );
    }

    return request;
  }
}
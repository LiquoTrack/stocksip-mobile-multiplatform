import 'package:http/http.dart' as http;
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_request_dto.dart';

extension WarehouseRequestMultipart on WarehouseRequestDto {
  Future<http.MultipartRequest> toMultipart(String url) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['addressStreet'] = addressStreet;
    request.fields['addressCity'] = addressCity;
    request.fields['addressDistrict'] = addressDistrict;
    request.fields['addressPostalCode'] = addressPostalCode;
    request.fields['addressCountry'] = addressCountry;
    request.fields['temperatureMin'] = temperatureMin.toString();
    request.fields['temperatureMax'] = temperatureMax.toString();
    request.fields['capacity'] = capacity.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );
    }

    return request;
  }
}

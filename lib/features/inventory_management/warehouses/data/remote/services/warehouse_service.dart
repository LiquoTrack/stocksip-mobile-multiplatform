import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_dto.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_request_dto.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/models/warehouse_wrapper_dto.dart';

class WarehouseService {
  final AuthHttpClient client;

  WarehouseService({required this.client});

  Future<WarehouseWrapperDto> getWarehousesByAccountId(String accountId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.warehousesByAccountId(accountId)}",
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = jsonDecode(response.body);
        return WarehouseWrapperDto.fromJson(jsonResponse);
      } else if (response.statusCode == HttpStatus.notFound) {
        return WarehouseWrapperDto(
          warehouses: [],
          total: 0,
          maxWarehousesAllowed: 0,
        );
      } else {
        throw Exception('Failed to load warehouses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching warehouses: $e');
    }
  }

  Future<bool> deleteWarehouse(String warehouseId) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.warehouseById(warehouseId)}",
    );

    try {
      final response = await client.delete(uri);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        return true;
      } else {
        throw Exception('Failed to delete warehouse: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting warehouse: $e');
    }
  }

  Future<WarehouseDto> registerWarehouse(
    String accountId,
    WarehouseRequestDto dto,
  ) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.warehousesByAccountId(accountId)}",
    );

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['Name'] = dto.name;
      request.fields['AddressStreet'] = dto.addressStreet;
      request.fields['AddressCity'] = dto.addressCity;
      request.fields['AddressDistrict'] = dto.addressDistrict;
      request.fields['AddressPostalCode'] = dto.addressPostalCode;
      request.fields['AddressCountry'] = dto.addressCountry;
      request.fields['TemperatureMin'] = dto.temperatureMin.toString();
      request.fields['TemperatureMax'] = dto.temperatureMax.toString();
      request.fields['Capacity'] = dto.capacity.toString();

      if (dto.imageFile != null) {
        var stream = http.ByteStream(dto.imageFile!.openRead());
        var length = await dto.imageFile!.length();
        var multipartFile = http.MultipartFile(
          'Image',
          stream,
          length,
          filename: basename(dto.imageFile!.path),
        );
        request.files.add(multipartFile);
      }

      final response = await client.sendMultipart(request);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        return WarehouseDto.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to register warehouse: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering warehouse: $e');
    }
  }

  Future<WarehouseDto> updateWarehouse(
    String warehouseId,
    WarehouseRequestDto dto,
  ) async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/${ApiConstants.warehouseById(warehouseId)}",
    );

    try {
      var request = http.MultipartRequest('PUT', uri);

      request.fields['Name'] = dto.name;
      request.fields['AddressStreet'] = dto.addressStreet;
      request.fields['AddressCity'] = dto.addressCity;
      request.fields['AddressDistrict'] = dto.addressDistrict;
      request.fields['AddressPostalCode'] = dto.addressPostalCode;
      request.fields['AddressCountry'] = dto.addressCountry;
      request.fields['TemperatureMin'] = dto.temperatureMin.toString();
      request.fields['TemperatureMax'] = dto.temperatureMax.toString();
      request.fields['Capacity'] = dto.capacity.toString();

      if (dto.imageFile != null) {
        var stream = http.ByteStream(dto.imageFile!.openRead());
        var length = await dto.imageFile!.length();
        var multipartFile = http.MultipartFile(
          'Image',
          stream,
          length,
          filename: basename(dto.imageFile!.path),
        );
        request.files.add(multipartFile);
      }

      final response = await client.sendMultipart(request);

      if (response.statusCode == HttpStatus.ok) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(respStr);
        return WarehouseDto.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to update warehouse: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating warehouse: $e');
    }
  }
}
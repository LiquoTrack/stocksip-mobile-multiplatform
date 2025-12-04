import 'package:http/http.dart' as http;
import 'package:stocksip/core/storage/token_storage.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _tokenStorage.read();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }

  Future<http.StreamedResponse> sendMultipart(http.MultipartRequest request) async {
    final token = await _tokenStorage.read();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request.send();
  }
}

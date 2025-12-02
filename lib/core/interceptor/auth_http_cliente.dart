import 'package:http/http.dart' as http;

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final Future<String?> Function() getToken;

  AuthHttpClient({required this.getToken});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await getToken();

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }
}

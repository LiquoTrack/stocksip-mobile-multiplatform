import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();
  final _key = 'token';

  Future<void> save(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<String?> read() async {
    return await _storage.read(key: _key);
  }

  Future<void> delete() async {
    await _storage.delete(key: _key);
  }
}
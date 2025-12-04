import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();
  final _key = 'token';
  final _accountId = 'account_id';
  final _userId = 'user_id';

  Future<void> save(String token, String accountId, {String? userId}) async {
    await _storage.write(key: _key, value: token);
    await _storage.write(key: _accountId, value: accountId);
    if (userId != null) {
      await _storage.write(key: _userId, value: userId);
    }
  }

  Future<String?> read() async {
    return await _storage.read(key: _key);
  }

  Future<String?> readAccountId() async {
    return await _storage.read(key: _accountId);
  }

  Future<String?> readUserId() async {
    return await _storage.read(key: _userId);
  }

    Future<void> delete() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _accountId);
    await _storage.delete(key: _userId);
  }
}
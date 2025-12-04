import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();
  final _key = 'token';
  final _accountId = 'account_id';
  final _userId = 'user_id';
  final _isFirstLogin = 'is_first_login';

  Future<void> save(String token, String accountId, {String? userId}) async {
    await _storage.write(key: _key, value: token);
    await _storage.write(key: _accountId, value: accountId);
    if (userId != null) {
      await _storage.write(key: _userId, value: userId);
    }

    await _storage.write(key: _isFirstLogin, value: 'true');
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

  Future<bool> isFirstLogin() async {
    final value = await _storage.read(key: _isFirstLogin);
    return value == 'true';
  }

  Future<void> markLoginComplete() async {
    await _storage.write(key: _isFirstLogin, value: 'false');
  }

  Future<void> delete() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _accountId);
    await _storage.delete(key: _userId);
    await _storage.delete(key: _isFirstLogin);
  }
}
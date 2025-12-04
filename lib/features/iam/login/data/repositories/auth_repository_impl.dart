import 'package:stocksip/core/common/utils/resource.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/domain/models/user.dart';
import 'package:stocksip/features/iam/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthService service;
  final TokenStorage tokenStorage;

  const AuthRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<User> signIn(String username, String password) async {
    final user = await service.login(username, password);
    await tokenStorage.save(user.token, user.accountId, userId: user.userId);
    return user;
  }

  @override
  Future<Resource<String>> signUp(String username, String email, String password, String accountRole, String businessName) async {
    return service.register(username, email, password, accountRole, businessName);
  }
}
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/data/remote/services/accounts_service.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/models/account_status.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {

  final AccountsService service;
  final TokenStorage tokenStorage;

  AccountRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  @override
  Future<AccountStatus> fetchAccountStatus() async {
    try {
      final accountId = await tokenStorage.readAccountId();

      if (accountId == null) {
        throw Exception('Account ID not found in storage');
      }
      
      final response = await service.getAccountStatus(accountId);
      return response.toDomain();
    } catch (e) {
      rethrow;
    }
  }
}
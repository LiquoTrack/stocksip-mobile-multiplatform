import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/models/account_status.dart';

abstract class AccountRepository {
  Future<AccountStatus> fetchAccountStatus();
}
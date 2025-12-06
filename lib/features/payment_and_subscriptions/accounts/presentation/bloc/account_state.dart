import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/models/account_status.dart';

class AccountState {
  final Status status;
  final AccountStatus accountStatus;
  final String? message;

  const AccountState({
    this.status = Status.initial,
    this.accountStatus = const AccountStatus(status: ''),
    this.message,
  });

  AccountState copyWith({
    Status? status,
    AccountStatus? accountStatus,
    String? message,
  }) {
    return AccountState(
      status: status ?? this.status,
      accountStatus: accountStatus ?? this.accountStatus,
      message: message ?? this.message,
    );
  }
}
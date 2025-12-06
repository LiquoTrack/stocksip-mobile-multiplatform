import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/models/account_status.dart';

class AccountStatusResponse {
  final String accountStatus;

  AccountStatusResponse({required this.accountStatus});

  factory AccountStatusResponse.fromJson(Map<String, dynamic> json) {
    return AccountStatusResponse(
      accountStatus: json['accountStatus'],
    );
  }

  AccountStatus toDomain() {
    return AccountStatus(status: accountStatus);
  }
}

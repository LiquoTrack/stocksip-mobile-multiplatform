import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';

class SubscriptionResponse {
  final String subscriptionId;
  final String planId;
  final String status;
  final String expirationDate;
  final String planType;
  final String paymentFrequency;
  final int maxUsers;
  final int maxProducts;
  final int maxWarehouses;

  SubscriptionResponse({
    required this.subscriptionId,
    required this.planId,
    required this.status,
    required this.expirationDate,
    required this.planType,
    required this.paymentFrequency,
    required this.maxUsers,
    required this.maxProducts,
    required this.maxWarehouses,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      subscriptionId: json['subscriptionId'],
      planId: json['planId'],
      status: json['status'],
      expirationDate: json['expirationDate'],
      planType: json['planType'],
      paymentFrequency: json['paymentFrequency'],
      maxUsers: json['maxUsers'] ?? 0,
      maxProducts: json['maxProducts'] ?? 0,
      maxWarehouses: json['maxWarehouses'] ?? 0,
    );
  }

  AccountSubscription toDomain() {
    return AccountSubscription(
      subscriptionId: subscriptionId,
      planId: planId,
      status: status,
      expirationDate: expirationDate,
      planType: planType,
      paymentFrequency: paymentFrequency,
      maxUsers: maxUsers,
      maxProducts: maxProducts,
      maxWarehouses: maxWarehouses,
    );
  }
}

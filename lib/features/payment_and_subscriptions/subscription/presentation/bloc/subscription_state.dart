import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/subscription.dart';

class SubscriptionState {
  final Status status;
  final Subscription? subscription;
  final AccountSubscription? accountSubscription;
  final String? initPoint;
  final String? message;

  const SubscriptionState({
    this.status = Status.initial,
    this.subscription,
    this.accountSubscription,
    this.initPoint,
    this.message,
  });

  SubscriptionState copyWith({
    Status? status,
    Subscription? subscription,
    AccountSubscription? accountSubscription,
    final String? initPoint,
    String? message,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      accountSubscription: accountSubscription ?? this.accountSubscription,
      initPoint: initPoint ?? this.initPoint,
      message: message ?? this.message,
    );
  }
}

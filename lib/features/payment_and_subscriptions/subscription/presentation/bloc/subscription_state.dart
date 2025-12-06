import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/subscription.dart';

class SubscriptionState {
  final Status status;
  final Subscription subscription;
  final String? message;
  final AccountSubscription? accountSubscription;

  const SubscriptionState({
    this.status = Status.initial,
    this.subscription = const Subscription(
      accountId: '',
      planId: '',
      preferenceId: '',
      initPoint: '',
      isPaymentLaunched: false,
    ),
    this.accountSubscription,
    this.message,
  });

  SubscriptionState copyWith({
    Status? status,
    Subscription? subscription,
    AccountSubscription? accountSubscription,
    String? message,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      accountSubscription: accountSubscription ?? this.accountSubscription,
      message: message ?? this.message,
    );
  }
}

import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/subscription.dart';

class SubscriptionState {
  final Status status;
  final Subscription subscription;
  final String? message;

  const SubscriptionState({
    this.status = Status.initial,
    this.subscription = const Subscription(
      accountId: '',
      planId: '',
      preferenceId: '',
      initPoint: '',
      isPaymentLaunched: false,
    ),
    this.message,
  });

  SubscriptionState copyWith({
    Status? status,
    Subscription? subscription,
    String? message,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      message: message ?? this.message,
    );
  }
}

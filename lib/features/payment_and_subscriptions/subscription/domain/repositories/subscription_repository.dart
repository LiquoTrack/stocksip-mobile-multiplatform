import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/subscription.dart';

abstract class SubscriptionRepository {
  
  Future<Subscription> createInitialSubscription({
    required String selectPlanId,
  });

  Future<AccountSubscription> fetchSubscriptionByAccountId();

  Future<Subscription> upgradeSubscription(String subscriptionId, String newPlanId);
}
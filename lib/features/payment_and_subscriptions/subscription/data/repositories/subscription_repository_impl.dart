import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/initial_susbcription_request_dto.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/upgrade_subscription_request_dto.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/services/subscriptions_service.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/subscription.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl extends SubscriptionRepository {

  final SubscriptionsService service;
  final TokenStorage tokenStorage;

  SubscriptionRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  @override
  Future<Subscription> createInitialSubscription({required String selectPlanId})async {
    try {

      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      final request = CreateSubscriptionRequest(selectedPlanId: selectPlanId);

      final response = await service.createInitialSubscription(
        request,
        accountId,
      );

      return Subscription(
        accountId: accountId,
        planId: selectPlanId,
        preferenceId: response.preferenceId,
        initPoint: response.initPoint,
        isPaymentLaunched: true,
      );

    } catch (e) {
      throw Exception('Failed to create initial subscription: $e');
    }
  }

  @override
  Future<AccountSubscription> fetchSubscriptionByAccountId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      final response =  await service.getSubscriptionDetails(accountId);

      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to fetch subscription: $e');
    }
  }

  @override
  Future<Subscription> upgradeSubscription(String subscriptionId, String newPlanId) async {
    try {

      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      final request = UpgradeSubscriptionRequest(newPlanId: newPlanId);

      final response = await service.upgradeSubscription(
        request,
        accountId,
        subscriptionId,
      );

      return Subscription(
        accountId: accountId,
        planId: newPlanId,
        preferenceId: response.preferenceId,
        initPoint: response.initPoint,
        isPaymentLaunched: true,
      );
    } catch (e) {
      throw Exception('Failed to upgrade subscription: $e');
    }
  }

}
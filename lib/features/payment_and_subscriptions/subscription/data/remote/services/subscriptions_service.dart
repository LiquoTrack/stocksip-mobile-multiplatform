import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/account_subscription_response_dto.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/create_subscriptions_response.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/initial_susbcription_request_dto.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/upgrade_subscription_request_dto.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/models/upgrade_subscription_response_dto.dart';

class SubscriptionsService {
  final AuthHttpClient client;

  SubscriptionsService({required this.client});

  Future<CreateSubscriptionResponse> createInitialSubscription(
    CreateSubscriptionRequest request,
    String accountId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}/${ApiConstants.accountSubscriptions(accountId)}",
      );

      final response = await client.post(
        uri,
        body: jsonEncode(request.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.created) {
        final jsonResponse = jsonDecode(response.body);
        return CreateSubscriptionResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to create subscription: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }

  Future<SubscriptionResponse> getSubscriptionDetails(String accountId) async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}/${ApiConstants.accountSubscriptions(accountId)}",
      );
      final response = await client.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = jsonDecode(response.body);
        return SubscriptionResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to fetch subscription details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching subscription details: $e');
    }
  }

  Future<UpgradeSubscriptionResponse> upgradeSubscription(
    UpgradeSubscriptionRequest request,
    String accountId,
    String subscriptionId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}/${ApiConstants.upgradeSubscription(accountId, subscriptionId)}",
      );
      final response = await client.post(
        uri,
        body: jsonEncode(request.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.created) {
        final jsonResponse = jsonDecode(response.body);
        return UpgradeSubscriptionResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to upgrade subscription: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error upgrading subscription: $e');
    }
  }
}

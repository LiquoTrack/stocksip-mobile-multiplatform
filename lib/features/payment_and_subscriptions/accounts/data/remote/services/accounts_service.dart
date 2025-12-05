import 'dart:convert';
import 'dart:io';

import 'package:stocksip/core/constants/api_constants.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/data/remote/models/account_status_response_dto.dart';

class AccountsService {
  final AuthHttpClient client;

  AccountsService({required this.client});

  Future<AccountStatusResponse> getAccountStatus(String accountId) async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}/${ApiConstants.accountStatus(accountId)}",
      );
      final response = await client.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = jsonDecode(response.body);
        return AccountStatusResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to fetch account status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching account status: $e');
    }
  }
}

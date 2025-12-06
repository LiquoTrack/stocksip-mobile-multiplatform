import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/data/remote/services/alerts_service.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsService service;
  final TokenStorage tokenStorage;

  const AlertsRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<List<Alert>> getAlerts() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) throw Exception('No accountId found');

      final dtos = await service.getAlertsByAccountId(accountId: accountId);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      return Future.error('$e');
    }
  }
}
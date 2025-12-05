import 'package:stocksip/features/alerts_and_notification/alerts/data/remote/services/alerts_service.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsService service;

  const AlertsRepositoryImpl({required this.service});

  @override
  Future<List<Alert>> getAlerts({required String accountId}) async {
    try {
      final dtos = await service.getAlertsByAccountId(accountId: accountId);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      return Future.error('$e');
    }
  }
}
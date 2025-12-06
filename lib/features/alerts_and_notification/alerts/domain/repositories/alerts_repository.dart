
import 'package:stocksip/features/alerts_and_notification/alerts/domain/models/alert.dart';

abstract class AlertsRepository {
  Future<List<Alert>> getAlerts();
}

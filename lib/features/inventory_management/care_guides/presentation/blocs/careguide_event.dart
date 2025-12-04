import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';

abstract class CareguideEvent {
  const CareguideEvent();
}

class GetCareGuidesByAccountIdEvent extends CareguideEvent {
  final String accountId;
  const GetCareGuidesByAccountIdEvent({required this.accountId});
}

class OnCareGuideCreated extends CareguideEvent {
  final CareGuide careGuide;
  const OnCareGuideCreated({required this.careGuide});
}

class OnCareGuideUpdated extends CareguideEvent {
  final String careGuideId;
  final CareGuide careGuide;
  const OnCareGuideUpdated({required this.careGuideId, required this.careGuide});
}

class OnCareGuideDeleted extends CareguideEvent {
  final String careGuideId;
  final String accountId; // to reload list
  const OnCareGuideDeleted({required this.careGuideId, required this.accountId});
}

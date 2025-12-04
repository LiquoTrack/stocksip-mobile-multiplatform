import '../../domain/models/plan.dart';

abstract class PlanEvent {
  const PlanEvent();
}

class GetAllPlansEvent extends PlanEvent {
  const GetAllPlansEvent();
}

class SelectPlanEvent extends PlanEvent {
  final Plan plan;

  const SelectPlanEvent({required this.plan});
}

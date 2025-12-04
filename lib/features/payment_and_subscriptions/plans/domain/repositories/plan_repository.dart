import '../../domain/models/plan.dart';

abstract class PlanRepository {
  Future<List<Plan>> getAllPlans();
}

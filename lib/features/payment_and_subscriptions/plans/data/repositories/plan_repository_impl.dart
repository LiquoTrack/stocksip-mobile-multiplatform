import 'package:stocksip/features/payment_and_subscriptions/plans/data/services/plan_service.dart';
import '../../domain/models/plan.dart';
import '../../domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanService apiService;

  PlanRepositoryImpl({required this.apiService});

  @override
  Future<List<Plan>> getAllPlans() async {
    try {
      final response = await apiService.getAllPlans();
      return response.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error fetching plans: $e');
    }
  }
}

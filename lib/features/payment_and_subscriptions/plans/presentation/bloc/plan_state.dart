import '../../domain/models/plan.dart';

class PlanState {
  final List<Plan> plans;
  final Plan? selectedPlan;
  final bool isLoading;
  final String? errorMessage;

  PlanState({
    this.plans = const [],
    this.selectedPlan,
    this.isLoading = false,
    this.errorMessage,
  });

  PlanState copyWith({
    List<Plan>? plans,
    Plan? selectedPlan,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlanState(
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/plan_repository.dart';
import 'plan_event.dart';
import 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final PlanRepository repository;

  PlanBloc({required this.repository}) : super(PlanState()) {
    on<GetAllPlansEvent>(_onGetAllPlans);
    on<SelectPlanEvent>(_onSelectPlan);
  }

  Future<void> _onGetAllPlans(
    GetAllPlansEvent event,
    Emitter<PlanState> emit,
  ) async {
    print('>>> [PlanBloc] GetAllPlansEvent triggered');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      print('>>> [PlanBloc] Fetching plans from repository');
      final plans = await repository.getAllPlans();
      print('>>> [PlanBloc] Plans fetched: ${plans.length}');
      emit(state.copyWith(
        plans: plans,
        isLoading: false,
      ));
    } catch (e) {
      print('>>> [PlanBloc] Error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSelectPlan(
    SelectPlanEvent event,
    Emitter<PlanState> emit,
  ) async {
    emit(state.copyWith(selectedPlan: event.plan));
  }
}

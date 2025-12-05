import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/repositories/subscription_repository.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionBloc({required this.repository})
    : super(const SubscriptionState()) {
    on<OnCreateInitialSubscription>(_onCreateInitialSubscription);
    on<GetSubscriptionByAccountId>(_onGetSubscriptionByAccountId);
    on<OnUpgradeSubscription>(_onUpgradeSubscription);
  }

Future<void> _onCreateInitialSubscription(
  OnCreateInitialSubscription event,
  Emitter<SubscriptionState> emit,
) async {
  emit(state.copyWith(status: Status.loading));

  try {
    final subscription = await repository.createInitialSubscription(
      selectPlanId: event.selectedPlanId,
    );

    if (subscription.initPoint == null) {
      emit(state.copyWith(
        status: Status.success,
        subscription: subscription,
        message: "Subscription created successfully (free plan)",
      ));
      return;
    }

    emit(state.copyWith(
      status: Status.success,
      subscription: subscription,
      message: "Subscription created successfully",
    ));
  } catch (e) {
    emit(state.copyWith(
      status: Status.failure,
      message: "Failed to create subscription: ${e.toString()}",
    ));
  }
}


  Future<void> _onGetSubscriptionByAccountId(
    GetSubscriptionByAccountId event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await repository.fetchSubscriptionByAccountId();
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onUpgradeSubscription(
    OnUpgradeSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final subscription = await repository.upgradeSubscription(
        event.subscriptionId,
        event.newPlanId,
      );
      emit(state.copyWith(status: Status.success, subscription: subscription));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to upgrade subscription",
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_state.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_state.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/widgets/available_plans.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/widgets/subscription_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(GetSubscriptionByAccountId());
    context.read<PlanBloc>().add(GetAllPlansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, subState) {
        return BlocBuilder<PlanBloc, PlanState>(
          builder: (context, planState) {
            return Scaffold(
              drawer: const DrawerNavigation(),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2B000D),
                      Color(0xFF5E2430),
                      Color(0xFF914852),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 48.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(38),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.menu, color: Colors.white),
                                ),
                              );
                            },
                          ),
                          const Text(
                            "Subscriptions",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (subState.status == Status.loading || planState.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF6B35),
                              ),
                            );
                          } else if (subState.status == Status.failure) {
                            return Center(
                              child: Text(
                                subState.message ?? "Failed to load subscription",
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              children: [
                                const SizedBox(height: 16),
                                if (subState.accountSubscription != null)
                                  SubscriptionCard(
                                    subscription: subState.accountSubscription!,
                                  ),
                                const SizedBox(height: 24),
                                AvailablePlansSection(
                                  currentPlanType: subState.accountSubscription?.planType ?? '',
                                  allPlans: planState.plans,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// lib/features/payment_and_subscriptions/plans/presentation/pages/choose_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/pages/app_web_view_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_state.dart';
import '../bloc/plan_bloc.dart';
import '../bloc/plan_event.dart';
import '../bloc/plan_state.dart';
import '../widgets/plan_card.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(const GetAllPlansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: MultiBlocListener(
          listeners: [
            BlocListener<SubscriptionBloc, SubscriptionState>(
              listener: (context, state) async {
                if (state.status == Status.loading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator(color: Colors.white)),
                  );
                }

                if (state.status == Status.failure) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? "Error creating subscription"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                if (state.status == Status.success) {
                  Navigator.pop(context);

                  final sub = state.subscription;

                  if (sub.initPoint == null || !sub.isPaymentLaunched) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Subscribed successfully!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    context.go('/home');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentWebView(url: sub.initPoint),
                      ),
                    );
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<PlanBloc, PlanState>(
            builder: (context, state) {
              if (state.isLoading && state.plans.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (state.plans.isEmpty) {
                return const Center(
                  child: Text(
                    'No plans available at the moment.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Choose Plan',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.plans.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final plan = state.plans[index];
                          return PlanCard(
                            plan: plan,
                            isSelected: state.selectedPlan?.id == plan.id,
                            onSelect: () {
                              context.read<PlanBloc>().add(
                                    SelectPlanEvent(plan: plan),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: ElevatedButton(
                        onPressed: state.selectedPlan != null
                            ? () {
                                final plan = state.selectedPlan!;
                                context.read<SubscriptionBloc>().add(
                                      OnCreateInitialSubscription(plan.id!),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: state.selectedPlan != null
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

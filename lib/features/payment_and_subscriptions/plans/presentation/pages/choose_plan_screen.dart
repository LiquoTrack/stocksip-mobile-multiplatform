import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/widgets/plan_card.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_state.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_state.dart';
import 'app_web_view_page.dart';

class ChoosePlanScreen extends StatefulWidget {
  final Function(dynamic)? onContinue;
  final VoidCallback? onBack;

  const ChoosePlanScreen({super.key, this.onContinue, this.onBack});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PlanBloc>().add(const GetAllPlansEvent());
      }
    });
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
              listener: (context, state) {
                if (state.status == Status.loading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                } else if (state.status == Status.failure) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? "Error creating subscription"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state.status == Status.success) {
                  Navigator.pop(context);
                  if (state.subscription?.initPoint != null && state.subscription!.initPoint!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentWebView(url: state.subscription!.initPoint!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Subscribed successfully!"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );                    
                    widget.onContinue?.call(state.subscription);
                    context.go('/home');
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<PlanBloc, PlanState>(
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Choose Plan',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 140,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF6B35),
                                  Color(0xFFFFA726),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _buildContent(context, state)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PlanState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<PlanBloc>().add(const GetAllPlansEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    if (state.plans.isEmpty) {
      return Center(
        child: Text(
          'No plans available.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: state.plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                return PlanCard(
                  plan: plan,
                  isSelected: state.selectedPlan?.id == plan.id,
                  onSelect: () {
                    context.read<PlanBloc>().add(SelectPlanEvent(plan: plan));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: ElevatedButton(
              onPressed: state.selectedPlan != null
                  ? () {
                      final plan = state.selectedPlan!;

                      context
                          .read<SubscriptionBloc>()
                          .add(OnCreateInitialSubscription(plan.id!));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                disabledBackgroundColor: const Color(0xFF4A1520),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: state.selectedPlan != null ? Colors.white : Colors.white54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

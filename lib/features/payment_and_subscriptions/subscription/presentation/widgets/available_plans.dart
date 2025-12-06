import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/domain/models/plan.dart';
import 'available_plan_card.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_state.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_event.dart';

class AvailablePlansSection extends StatefulWidget {
  final String currentPlanType;
  final List<Plan> allPlans;
  final void Function(Plan selectedPlan)? onPlanSelected;

  const AvailablePlansSection({
    super.key,
    required this.currentPlanType,
    required this.allPlans,
    this.onPlanSelected,
  });

  @override
  State<AvailablePlansSection> createState() => _AvailablePlansSectionState();
}

class _AvailablePlansSectionState extends State<AvailablePlansSection> {
  String? selectedPlanId;

  @override
  Widget build(BuildContext context) {
    const planHierarchy = ["Free", "Premium", "Enterprise"];
    final currentIndex = planHierarchy.indexOf(widget.currentPlanType);

    final availablePlans = widget.allPlans.where((plan) {
      final idx = planHierarchy.indexOf(plan.planType);
      return idx > currentIndex;
    }).toList();

    return _buildContent(context, availablePlans);
  }

  Widget _buildContent(BuildContext context, List<Plan> availablePlans) {
    if (availablePlans.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF3D1520), Color(0xFF2B0D15)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: const [
                Icon(Icons.workspace_premium, color: Colors.orange, size: 50),
                SizedBox(height: 14),
                Text(
                  "You are already on the highest plan!",
                  style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6),
                Text(
                  "No higher plans available.",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Upgrades",
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...availablePlans.map(
          (plan) => GestureDetector(
            onTap: () {
              setState(() => selectedPlanId = plan.id);
            },
            child: AvailablePlanCard(
              plan: plan,
              isSelected: plan.id == selectedPlanId,
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            final isLoading = state.status == Status.loading;

            return ElevatedButton(
              onPressed: selectedPlanId != null && !isLoading
                  ? () {
                      final subId = state.accountSubscription?.subscriptionId ?? "";
                      context.read<SubscriptionBloc>().add(OnUpgradeSubscription(subId, selectedPlanId!));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPlanId != null ? Colors.orange : Colors.grey[700],
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upgrade", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            );
          },
        ),
      ],
    );
  }
}

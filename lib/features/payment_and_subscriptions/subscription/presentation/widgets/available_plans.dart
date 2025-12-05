import 'package:flutter/material.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/domain/models/plan.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/widgets/available_plan_card.dart';

class AvailablePlansSection extends StatefulWidget {
  final String currentPlanType;
  final List<Plan> allPlans;

  const AvailablePlansSection({
    super.key,
    required this.currentPlanType,
    required this.allPlans,
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
      final planIndex = planHierarchy.indexOf(plan.planType);
      return planIndex > currentIndex;
    }).toList();

    if (availablePlans.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.celebration, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            "Congratulations!",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You already have the highest plan.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Upgrades",
          style: TextStyle(
              color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...availablePlans.map(
          (plan) => GestureDetector(
            onTap: () => setState(() => selectedPlanId = plan.id),
            child: AvailablePlanCard(plan: plan, isSelected: plan.id == selectedPlanId),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: selectedPlanId != null
              ? () {
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedPlanId != null ? Colors.orange : Colors.grey[700],
            minimumSize: const Size.fromHeight(56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text(
            "Upgrade",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
  }
}
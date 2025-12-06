import 'package:flutter/material.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/domain/models/plan.dart';

class AvailablePlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  const AvailablePlanCard({
    super.key,
    required this.plan,
    this.isSelected = false,
  });
  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.orange : Colors.white24;
    final gradient = isSelected
        ? const LinearGradient(colors: [Color(0xFF3D1520), Color(0xFF2B0D15)])
        : const LinearGradient(colors: [Color(0xFF1F0009), Color(0xFF1A0008)]);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.planType,
                  style: TextStyle(
                    color: isSelected ? Colors.orange : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (plan.description != null)
                  Text(
                    plan.description!,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                const SizedBox(height: 8),
                Text(
                  "Price: \$${plan.planPrice}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          isSelected
              ? const Icon(Icons.check_circle, color: Colors.orange, size: 32)
              : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                ),
        ],
      ),
    );
  }
}

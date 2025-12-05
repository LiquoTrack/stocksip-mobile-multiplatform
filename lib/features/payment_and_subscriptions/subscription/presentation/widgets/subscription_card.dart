import 'package:flutter/material.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/domain/models/account_subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final AccountSubscription subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A0008),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B0D15), Color(0xFF1A0008)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Your Current Plan",
                    style: TextStyle(
                      color: Colors.white.withAlpha(179),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription.planType,
                    style: const TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withAlpha(25)),
            InfoRow(
              label: "Status",
              value: subscription.status,
              valueColor: subscription.status.toLowerCase() == "active"
                  ? Colors.green
                  : Colors.red,
            ),
            InfoRow(
              label: "Expiration",
              value: subscription.expirationDate == "12/31/9999"
                  ? "Unlimited"
                  : subscription.expirationDate,
              valueColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withAlpha(25)),
            const Text(
              "Plan Benefits",
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BenefitItem(
              label: "Max Users Allowed",
              value: subscription.maxUsers.toString(),
            ),
            BenefitItem(
              label: "Max Products Allowed",
              value: subscription.maxProducts.toString(),
            ),
            BenefitItem(
              label: "Max Warehouses Allowed",
              value: subscription.maxWarehouses.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String label;
  final String value;

  const BenefitItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../domain/models/plan.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const PlanCard({
    Key? key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  bool get isPopular => plan.paymentFrequency == 'Monthly';

  Color get borderColor => isSelected ? const Color(0xFFFF6B35) : const Color(0xFF3A1520);

  Color get textColor => isPopular ? const Color(0xFF2B000D) : Colors.white;

  double extractPrice(String priceString) {
    final regex = RegExp(r'(\d+\.?\d*)');
    final match = regex.firstMatch(priceString);
    return double.tryParse(match?.group(1) ?? '0') ?? 0.0;
  }

  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 20 : 8,
      shadowColor: isSelected ? const Color(0xFFFF6B35).withOpacity(0.5) : Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: borderColor,
          width: isSelected ? 3 : 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: isPopular
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFA726), Color(0xFFFF8A50)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A0810), Color(0xFF2D1520)],
                ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Plan Type
                  Text(
                    plan.planType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatPrice(extractPrice(plan.planPrice)),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          plan.paymentFrequency == 'Monthly' ? '/month' : '/year',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Discount badge for yearly
                  if (plan.paymentFrequency == 'Yearly')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Save 39%!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (plan.paymentFrequency == 'Yearly') const SizedBox(height: 16),

                  // Description
                  if (plan.description != null && plan.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        plan.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ),

                  // Divider
                  Container(
                    width: 240,
                    height: 1,
                    color: textColor.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                  ),

                  const SizedBox(height: 16),

                  // Features
                  if (plan.planLimits != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plan.planLimits!.maxUsers != null)
                          FeatureItem(
                            text: plan.planLimits!.maxUsers == 2147483647
                                ? 'Unlimited users'
                                : 'Up to ${plan.planLimits!.maxUsers} users',
                            textColor: textColor,
                          ),
                        if (plan.planLimits!.maxWarehouses != null)
                          FeatureItem(
                            text: plan.planLimits!.maxWarehouses == 2147483647
                                ? 'Unlimited warehouses'
                                : 'Up to ${plan.planLimits!.maxWarehouses} warehouses',
                            textColor: textColor,
                          ),
                        if (plan.planLimits!.maxProducts != null)
                          FeatureItem(
                            text: plan.planLimits!.maxProducts == 2147483647
                                ? 'Unlimited products'
                                : 'Up to ${plan.planLimits!.maxProducts} products',
                            textColor: textColor,
                          ),
                        if (plan.planLimits!.storageGuides == true)
                          FeatureItem(text: 'Storage guides', textColor: textColor),
                        if (plan.planLimits!.premiumStorageGuides == true)
                          FeatureItem(text: 'Premium storage guides', textColor: textColor),
                        if (plan.planLimits!.communitySupport == true)
                          FeatureItem(text: 'Community support', textColor: textColor),
                        if (plan.planLimits!.prioritySupport == true)
                          FeatureItem(text: 'Priority support', textColor: textColor),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;
  final Color textColor;

  const FeatureItem({
    Key? key,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            color: Color(0xFF4CAF50),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

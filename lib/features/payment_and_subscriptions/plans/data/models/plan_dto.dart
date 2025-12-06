import '../../domain/models/plan.dart';
import '../../domain/models/plan_limits.dart';

class PlanDto {
  final String? planId;
  final String? planType;
  final String? description;
  final String? paymentFrequency;
  final double? price;
  final String? currency;
  final int? maxUsers;
  final int? maxWarehouses;
  final int? maxProducts;

  PlanDto({
    this.planId,
    this.planType,
    this.description,
    this.paymentFrequency,
    this.price,
    this.currency,
    this.maxUsers,
    this.maxWarehouses,
    this.maxProducts,
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    return PlanDto(
      planId: json['planId'] as String?,
      planType: json['planType'] as String?,
      description: json['description'] as String?,
      paymentFrequency: json['paymentFrequency'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      maxUsers: json['maxUsers'] as int?,
      maxWarehouses: json['maxWarehouses'] as int?,
      maxProducts: json['maxProducts'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planType': planType,
      'description': description,
      'paymentFrequency': paymentFrequency,
      'price': price,
      'currency': currency,
      'maxUsers': maxUsers,
      'maxWarehouses': maxWarehouses,
      'maxProducts': maxProducts,
    };
  }

  Plan toDomain() {
    return Plan(
      id: planId ?? 'Unknown',
      planType: planType ?? 'Unknown',
      description: description,
      paymentFrequency: paymentFrequency,
      planPrice: '${price ?? 0.0} ${currency ?? 'USD'}',
      planLimits: PlanLimits(
        maxUsers: maxUsers,
        maxWarehouses: maxWarehouses,
        maxProducts: maxProducts,
      ),
    );
  }
}

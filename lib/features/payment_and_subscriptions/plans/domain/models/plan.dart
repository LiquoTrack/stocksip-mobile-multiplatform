import 'plan_limits.dart';

class Plan {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String planType;
  final String? description;
  final String? paymentFrequency;
  final String planPrice;
  final PlanLimits? planLimits;
  final bool isMaxPlanMessage;

  Plan({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.planType,
    this.description,
    this.paymentFrequency,
    required this.planPrice,
    this.planLimits,
    this.isMaxPlanMessage = false,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['planId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      planType: json['planType'] as String? ?? 'Unknown',
      description: json['description'] as String?,
      paymentFrequency: json['paymentFrequency'] as String?,
      planPrice: '${json['price'] ?? 0.0} ${json['currency'] ?? 'USD'}',
      planLimits: json['planLimits'] != null
          ? PlanLimits.fromJson(json['planLimits'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'planType': planType,
      'description': description,
      'paymentFrequency': paymentFrequency,
      'planPrice': planPrice,
      'planLimits': planLimits?.toJson(),
    };
  }

  Plan copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? planType,
    String? description,
    String? paymentFrequency,
    String? planPrice,
    PlanLimits? planLimits,
  }) {
    return Plan(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      planType: planType ?? this.planType,
      description: description ?? this.description,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      planPrice: planPrice ?? this.planPrice,
      planLimits: planLimits ?? this.planLimits,
    );
  }
}

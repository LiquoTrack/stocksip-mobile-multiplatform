class UpgradeSubscriptionRequest {
  final String newPlanId;

  UpgradeSubscriptionRequest({required this.newPlanId});

  factory UpgradeSubscriptionRequest.fromJson(Map<String, dynamic> json) {
    return UpgradeSubscriptionRequest(
      newPlanId: json['newPlanId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newPlanId': newPlanId,
    };
  }
}

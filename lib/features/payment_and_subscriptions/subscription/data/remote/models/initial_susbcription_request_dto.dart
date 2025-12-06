class CreateSubscriptionRequest {
  final String selectedPlanId;

  CreateSubscriptionRequest({required this.selectedPlanId});

  Map<String, dynamic> toJson() {
    return {
      'selectedPlanId': selectedPlanId,
    };
  }

  factory CreateSubscriptionRequest.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionRequest(
      selectedPlanId: json['selectedPlanId'],
    );
  }
}

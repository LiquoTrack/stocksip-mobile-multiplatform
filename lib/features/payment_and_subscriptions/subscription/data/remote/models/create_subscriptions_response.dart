class CreateSubscriptionResponse {
  final String? preferenceId;
  final String? initPoint;
  final String? message;

  CreateSubscriptionResponse({
    this.preferenceId,
    this.initPoint,
    this.message,
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponse(
      preferenceId: json['preferenceId'] as String?,
      initPoint: json['initPoint'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferenceId': preferenceId,
      'initPoint': initPoint,
      'message': message,
    };
  }
}

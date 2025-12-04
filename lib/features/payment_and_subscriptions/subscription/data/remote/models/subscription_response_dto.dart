class CreateSubscriptionResponse {
  final String preferenceId;
  final String initPoint;
  final String message;

  CreateSubscriptionResponse({
    required this.preferenceId,
    required this.initPoint,
    required this.message,
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponse(
      preferenceId: json['preferenceId'],
      initPoint: json['initPoint'],
      message: json['message'],
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

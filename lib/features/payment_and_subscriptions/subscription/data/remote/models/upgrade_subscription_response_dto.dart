class UpgradeSubscriptionResponse {
  final String preferenceId;
  final String initPoint;
  final String message;

  UpgradeSubscriptionResponse({
    required this.preferenceId,
    required this.initPoint,
    required this.message,
  });

  factory UpgradeSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return UpgradeSubscriptionResponse(
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

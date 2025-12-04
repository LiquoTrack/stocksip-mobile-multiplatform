class Subscription {

  final String accountID;
  final String planId;
  final String? preferenceId;
  final String initPoint;
  final bool isPaymentLaunched;

  const Subscription({
    required this.accountID,
    required this.planId,
    this.preferenceId,
    required this.initPoint,
    required this.isPaymentLaunched,
  });

  Subscription copyWith({
    String? accountID,
    String? planId,
    String? preferenceId,
    String? initPoint,
    bool? isPaymentLaunched,
  }) {
    return Subscription(
      accountID: accountID ?? this.accountID,
      planId: planId ?? this.planId,
      preferenceId: preferenceId ?? this.preferenceId,
      initPoint: initPoint ?? this.initPoint,
      isPaymentLaunched: isPaymentLaunched ?? this.isPaymentLaunched,
    );
  }
}
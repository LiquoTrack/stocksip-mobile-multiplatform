class Subscription {

  final String accountId;
  final String planId;
  final String? preferenceId;
  final String? initPoint;
  final bool isPaymentLaunched;

  const Subscription({
    required this.accountId,
    required this.planId,
    this.preferenceId,
    this.initPoint,
    required this.isPaymentLaunched,
  });

  Subscription copyWith({
    String? accountId,
    String? planId,
    String? preferenceId,
    String? initPoint,
    bool? isPaymentLaunched,
  }) {
    return Subscription(
      accountId: accountId ?? this.accountId,
      planId: planId ?? this.planId,
      preferenceId: preferenceId ?? this.preferenceId,
      initPoint: initPoint ?? this.initPoint,
      isPaymentLaunched: isPaymentLaunched ?? this.isPaymentLaunched,
    );
  }
}
class AccountSubscription {

  final String subscriptionId;
  final String planId;
  final String status;
  final String expirationDate;
  final String planType;
  final String paymentFrequency;
  final int maxUsers;
  final int maxProducts;
  final int maxWarehouses;

  const AccountSubscription({
    required this.subscriptionId,
    required this.planId,
    required this.status,
    required this.expirationDate,
    required this.planType,
    required this.paymentFrequency,
    required this.maxUsers,
    required this.maxProducts,
    required this.maxWarehouses,
  });

  AccountSubscription copyWith({
    String? subscriptionId,
    String? planId,
    String? status,
    String? expirationDate,
    String? planType,
    String? paymentFrequency,
    int? maxUsers,
    int? maxProducts,
    int? maxWarehouses,
  }) {
    return AccountSubscription(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      expirationDate: expirationDate ?? this.expirationDate,
      planType: planType ?? this.planType,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      maxUsers: maxUsers ?? this.maxUsers,
      maxProducts: maxProducts ?? this.maxProducts,
      maxWarehouses: maxWarehouses ?? this.maxWarehouses,
    );
  }
}
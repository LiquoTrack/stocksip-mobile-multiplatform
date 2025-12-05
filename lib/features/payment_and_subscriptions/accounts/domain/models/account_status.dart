class AccountStatus {
  final String status;

  const AccountStatus({
    required this.status,
  });

  AccountStatus copyWith({
    String? status,
  }) {
    return AccountStatus(
      status: status ?? this.status,
    );
  }
}
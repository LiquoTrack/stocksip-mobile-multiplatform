class Account {
  final String role;

  const Account({
    required this.role,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      role: json['role'],
    );
  }
}
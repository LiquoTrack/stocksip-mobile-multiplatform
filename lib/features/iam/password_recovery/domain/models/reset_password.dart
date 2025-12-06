class ResetPassword {
  final String email;
  final String newPassword;

  const ResetPassword({
    required this.email,
    required this.newPassword,
  });

  ResetPassword copyWith({
    String? email,
    String? newPassword,
  }) {
    return ResetPassword(
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}
class VerifyCode {

  final String email;
  final String code;

  const VerifyCode({
    required this.email,
    required this.code,
  });

  VerifyCode copyWith({
    String? email,
    String? code,
  }) {
    return VerifyCode(
      email: email ?? this.email,
      code: code ?? this.code,
    );
  }
}
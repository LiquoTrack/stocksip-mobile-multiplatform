class SendEmail {
  final String email;

  const SendEmail({required this.email});

  SendEmail copyWith({String? email}) {
    return SendEmail(email: email ?? this.email);
  }
}
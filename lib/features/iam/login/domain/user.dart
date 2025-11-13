class User {
  final String token;
  final String userId;
  final String email;
  final String username;
  final String accountId;

  /// Constructs a User instance with the given parameters.
  const User({
    required this.token,
    required this.userId,
    required this.email,
    required this.username,
    required this.accountId,
  });

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['firstName'],
      userId: json['lastName'],
      email: json['email'],
      username: json['token'],
      accountId: json['accountId'],
    );
  }
}
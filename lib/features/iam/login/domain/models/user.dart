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

  /// Creates a User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json['userId'],
      email: json['email'],
      username: json['username'],
      accountId: json['accountId'],
    );
  }
}
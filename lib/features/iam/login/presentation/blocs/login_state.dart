import 'package:stocksip/core/enums/status.dart';

/// Represents the state of the login process.
class LoginState {
  final Status status;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final String? message;

  /// Constructs a LoginState with optional parameters.
  const LoginState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.message,
  });

  /// Creates a copy of the current LoginState with optional new values.
  /// If a parameter is not provided, the current value is retained.
  LoginState copyWith({
    Status? status,
    String? email,
    String? password,
    bool? isPasswordVisible,
    String? message,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      message: message ?? this.message,
    );
  }
}
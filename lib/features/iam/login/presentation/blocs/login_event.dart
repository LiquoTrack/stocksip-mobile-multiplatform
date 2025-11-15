/// Represents the various events that can occur in the login process.
abstract class LoginEvent {
  const LoginEvent();
}

class Login extends LoginEvent {
  const Login();
}

/// Event triggered when the email input changes
class OnEmailChanged extends LoginEvent {
  final String email;
  const OnEmailChanged({required this.email});
}

/// Event triggered when the password input changes
class OnPasswordChanged extends LoginEvent {
  final String password;
  const OnPasswordChanged({required this.password});
}

/// Event triggered to toggle the visibility of the password input
class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}
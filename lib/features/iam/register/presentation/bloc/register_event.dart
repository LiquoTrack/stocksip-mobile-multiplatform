import 'package:stocksip/features/iam/register/domain/account_role.dart';

/// Represents the various events that can occur during the user registration process.
abstract class RegisterEvent {
  const RegisterEvent();
}

/// Indicates that the user has submitted the registration form.
class Register extends RegisterEvent {
  const Register();
}

/// Indicates that the username field has changed.
class OnUsernameChanged extends RegisterEvent {
  final String username;
  const OnUsernameChanged({required this.username});
}

/// Indicates that the email field has changed.
class OnEmailChanged extends RegisterEvent {
  final String email;
  const OnEmailChanged({required this.email});
}

/// Indicates that the password field has changed.
class OnPasswordChanged extends RegisterEvent {
  final String password;
  const OnPasswordChanged({required this.password});
}

/// Indicates that the business name field has changed.
class OnBusinessNameChanged extends RegisterEvent {
  final String businessName;
  const OnBusinessNameChanged({required this.businessName});
}

/// Indicates that the account role selection has changed.
class OnAccountRoleChanged extends RegisterEvent {
  final AccountRole accountRole;
  const OnAccountRoleChanged({required this.accountRole});
}

/// Indicates that the user has toggled the password visibility.
class TogglePasswordVisibility extends RegisterEvent {
  const TogglePasswordVisibility();
}

/// Indicates that the confirm password field has changed.
class OnConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  const OnConfirmPasswordChanged({required this.confirmPassword});
}

class ClearMessage extends RegisterEvent {
  const ClearMessage();
}

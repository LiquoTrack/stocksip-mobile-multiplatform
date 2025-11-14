import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/register/domain/account_role.dart';

class RegisterState {

  final Status status;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;  
  final String businessName;
  final AccountRole accountRole;
  final bool isPasswordVisible;
  final bool doPasswordsMatch;
  final bool isPasswordLongEnough;
  final String? message;

  /// Constructor
  /// [status] - The current status of the registration process.
  /// [username] - The username entered by the user.
  /// [email] - The email entered by the user.
  /// [password] - The password entered by the user.
  /// [confirmPassword] - The confirmation password entered by the user.
  /// [accountRole] - The account role selected by the user.
  /// [businessName] - The business name entered by the user.
  /// [isPasswordVisible] - Flag indicating if the password is visible.
  /// [doPasswordsMatch] - Flag indicating if the password and confirmation password match.
  /// [isPasswordLongEnough] - Flag indicating if the password meets the minimum length requirement.  
  /// [message] - An optional message, typically used for error messages.
  const RegisterState({
    this.status = Status.initial,
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.businessName = '',
    this.accountRole = AccountRole.liquorstoreowner,
    this.isPasswordVisible = false,
    this.doPasswordsMatch = true,
    this.isPasswordLongEnough = false,
    this.message,    
  });

  /// Creates a copy of the current state with optional new values.
  RegisterState copyWith({
    Status? status,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? businessName,
    AccountRole? accountRole,
    bool? isPasswordVisible,
    bool? doPasswordsMatch,
    bool? isPasswordLongEnough,
    String? message,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      businessName: businessName ?? this.businessName,
      accountRole: accountRole ?? this.accountRole,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
      isPasswordLongEnough: isPasswordLongEnough ?? this.isPasswordLongEnough,
      message: message ?? this.message,
    );
  }
}
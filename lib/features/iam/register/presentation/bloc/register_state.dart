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
  final bool isEmailValid;
  final bool isBusinessNameValid;
  final String? message;

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
    this.isEmailValid = true,
    this.isBusinessNameValid = false,
    this.message,
  });

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
    bool? isEmailValid,
    bool? isBusinessNameValid,
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
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isBusinessNameValid: isBusinessNameValid ?? this.isBusinessNameValid,
      message: message ?? this.message,
    );
  }

  bool get isFormValid =>
      username.isNotEmpty &&
      email.isNotEmpty &&
      isEmailValid &&
      isPasswordLongEnough &&
      isBusinessNameValid &&
      doPasswordsMatch;

  bool get isUserInfoValid =>
      username.isNotEmpty &&
      email.isNotEmpty &&
      isEmailValid &&
      isPasswordLongEnough &&
      doPasswordsMatch;
}

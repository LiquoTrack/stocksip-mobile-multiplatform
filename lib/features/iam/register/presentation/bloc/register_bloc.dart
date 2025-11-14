import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/register/domain/account_role.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_event.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_state.dart';
import 'package:stocksip/core/enums/status.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService service;

  RegisterBloc({required this.service}) : super(RegisterState()) {
    on<OnUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<OnEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
      _validateEmail(emit, event.email);
    });

    on<OnPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
      _validatePasswords(emit);
    });

    on<OnBusinessNameChanged>((event, emit) {
      emit(state.copyWith(businessName: event.businessName));
      _validateBusinessName(emit, event.businessName);
    });

    on<OnAccountRoleChanged>((event, emit) {
      emit(state.copyWith(accountRole: event.accountRole));
    });

    on<OnConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
      _validatePasswords(emit);
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<Register>(_onRegister);
  }

  void _validateEmail(Emitter<RegisterState> emit, String email) {
    final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    emit(
      state.copyWith(
        isEmailValid: isValid,
        message: isValid ? null : 'Invalid email format',
      ),
    );
  }

  void _validatePasswords(Emitter<RegisterState> emit) {
    final password = state.password;
    final confirmPassword = state.confirmPassword;

    final longEnough = password.length >= 8;
    final match = password == confirmPassword;
    String? message;

    if (password.isNotEmpty && !longEnough) {
      message = "Password must be at least 8 characters long.";
    } else if (password.isNotEmpty && confirmPassword.isNotEmpty && !match) {
      message = "Passwords do not match.";
    }

    emit(
      state.copyWith(
        isPasswordLongEnough: longEnough,
        doPasswordsMatch: match,
        message: message,
      ),
    );
  }

  void _validateBusinessName(Emitter<RegisterState> emit, String businessName) {
    final isValid = businessName.length >= 3;
    emit(
      state.copyWith(
        isBusinessNameValid: isValid,
        message: isValid
            ? null
            : "Business name must be at least 3 characters long",
      ),
    );
  }

  FutureOr<void> _onRegister(
    Register event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await service.register(
        state.email,
        state.password,
        state.username,
        state.businessName,
        state.accountRole.toApi(),
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}

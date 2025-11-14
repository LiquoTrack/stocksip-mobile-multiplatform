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
    });

    on<OnPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
      _validatePasswords(emit);
    });

    on<OnBusinessNameChanged>((event, emit) {
      emit(state.copyWith(businessName: event.businessName));
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

  /// Validate both passwords
  void _validatePasswords(Emitter<RegisterState> emit) {
    final newPassword = state.password;
    final newConfirmPassword = state.confirmPassword;

    emit(
      state.copyWith(
        isPasswordLongEnough: newPassword.length >= 8 && newConfirmPassword.length >= 8,
        doPasswordsMatch: newPassword == newConfirmPassword,
      ),
    );
  }

  /// Handles the registration process when the Register event is triggered.
  FutureOr<void> _onRegister(
    Register event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await service.register(
        state.username,
        state.email,
        state.password,
        state.businessName,
        state.accountRole.toApi(),
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_event.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_state.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthService service;
  final FlutterSecureStorage storage;

  LoginBloc({required this.service, required this.storage}) : super(LoginState()) {
    on<OnEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<OnPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<Login>(_onLogin);
  }

  FutureOr<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final user = await service.login(state.email, state.password);

          
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'accountId', value: user.accountId);

      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
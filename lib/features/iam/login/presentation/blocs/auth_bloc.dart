import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/iam/login/domain/models/auth_status.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final TokenStorage tokenStorage;

  AuthBloc({required this.tokenStorage}) : super(const AuthState()) {
    on<AppStarted>(_onAppStarted);
    on<LogOut>(_onLogOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {

    final token = await tokenStorage.read();

    emit(
      state.copyWith(
        status: token != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }

  Future<void> _onLogOut(LogOut event, Emitter<AuthState> emit) async {
    await tokenStorage.delete();
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
      ),
    );
  }
}
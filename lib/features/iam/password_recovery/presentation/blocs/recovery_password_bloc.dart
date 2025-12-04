import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/reset_password.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/send_email.dart';
import 'package:stocksip/features/iam/password_recovery/domain/models/verify_code.dart';
import 'package:stocksip/features/iam/password_recovery/domain/repositories/recovery_password_repository.dart';
import 'package:stocksip/features/iam/password_recovery/presentation/blocs/recovery_password_event.dart';
import 'package:stocksip/features/iam/password_recovery/presentation/blocs/recovery_password_state.dart';

class RecoveryPasswordBloc
    extends Bloc<RecoveryPasswordEvent, RecoveryPasswordState> {
  final RecoveryPasswordRepository repository;

  RecoveryPasswordBloc({required this.repository})
    : super(const RecoveryPasswordState()) {
    on<SendRecoveryEmailEvent>(_onSendRecoveryEmail);
    on<VerifyRecoveryCodeEvent>(_onVerifyRecoveryCode);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendRecoveryEmail(
    SendRecoveryEmailEvent event,
    Emitter<RecoveryPasswordState> emit,
  ) async {
    try {
      final sendEmail = SendEmail(email: event.email);
      emit(state.copyWith(status: Status.loading));
      await repository.sendRecoveryEmail(sendEmail);
      emit(state.copyWith(status: Status.success, sendEmail: sendEmail));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onVerifyRecoveryCode(
    VerifyRecoveryCodeEvent event,
    Emitter<RecoveryPasswordState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      final verifyCode = VerifyCode(email: event.email, code: event.code);
      await repository.verifyRecoveryCode(verifyCode);
      emit(state.copyWith(status: Status.success, verifyCode: verifyCode));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<RecoveryPasswordState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      final ResetPassword resetPassword = ResetPassword(
        email: event.email,
        newPassword: event.resetPassword,
      );
      await repository.resetPassword(resetPassword);
      emit(
        state.copyWith(status: Status.success, resetPassword: resetPassword),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}

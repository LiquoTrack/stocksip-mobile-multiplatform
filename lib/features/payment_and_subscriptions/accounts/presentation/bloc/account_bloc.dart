import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/domain/repositories/account_repository.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  final AccountRepository repository;  

  AccountBloc(this.repository) : super(const AccountState()) {
    on<GetAccountStatus>(_onGetAccountStatus);
  }

  Future<void> _onGetAccountStatus(
      GetAccountStatus event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final accountStatus = await repository.fetchAccountStatus();
      emit(state.copyWith(
          status: Status.success, accountStatus: accountStatus));
    } catch (e) {
      emit(state.copyWith(
          status: Status.failure, message: e.toString()));
    }
  }
}
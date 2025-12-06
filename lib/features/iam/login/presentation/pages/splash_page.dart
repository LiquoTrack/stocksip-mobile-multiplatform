import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/home/presentation/pages/home_page.dart';
import 'package:stocksip/features/iam/login/domain/models/auth_status.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_state.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_state.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/pages/choose_plan_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool _requestedAccountStatus = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        
        if (authState.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }

        if (authState.status == AuthStatus.authenticated && !_requestedAccountStatus) {
          _requestedAccountStatus = true;
          context.read<AccountBloc>().add(GetAccountStatus());
        }

        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {

            if (accountState.status == Status.initial || accountState.status == Status.loading) {
              return Scaffold(
                body: SizedBox.expand(
                  child: Lottie.asset(
                    'assets/lottie/stocksip_splash.json',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }

            if (accountState.status == Status.failure) {
              return const LoginPage();
            }

            if (accountState.accountStatus.status == "Inactive") {
                return const ChoosePlanScreen();
            }

            if (accountState.accountStatus.status == "Active") {
              return const HomePage();
            }

            return Scaffold(
              body: Lottie.asset(
                'assets/lottie/stocksip_splash.json',
                fit: BoxFit.cover,
              ),
            );
          },
        );
      },
    );
  }
}

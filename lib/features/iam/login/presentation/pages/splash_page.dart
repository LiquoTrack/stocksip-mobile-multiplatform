import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stocksip/features/home/presentation/pages/home_page.dart';
import 'package:stocksip/features/iam/login/domain/models/auth_status.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_state.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }

        if (state.status == AuthStatus.authenticated) {
          return const HomePage();
        }

        return Scaffold(
          body: SizedBox.expand(
            child: Lottie.asset(
              'assets/lottie/stocksip_splash.json',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

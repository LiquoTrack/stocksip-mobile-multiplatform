import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_state.dart';
import 'package:stocksip/core/enums/status.dart';

class RegisterAccountPage extends StatelessWidget {
  const RegisterAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          case Status.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Unknown error')),
            );
          default:
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Account'),
        ),
        body: const Center(
          child: Text('Registration Form Goes Here'),
        ),
      ),
    );
  }
}
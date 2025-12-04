import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:stocksip/features/iam/register/domain/account_role.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_event.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_state.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/shared/presentation/widgets/stocksip_title.dart';

class RegisterAccountPage extends StatelessWidget {
  const RegisterAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Registration successful'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            break;
          case Status.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Unknown error'),
                backgroundColor: Colors.red,
              ),
            );
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.4,
              child: Container(color: const Color(0xFF2B000D)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: const Color(0xFFF4ECEC)),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StockSipLogo(),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Choose Your Role *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          BlocSelector<
                            RegisterBloc,
                            RegisterState,
                            AccountRole
                          >(
                            selector: (state) => state.accountRole,
                            builder: (context, selectedRole) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            selectedRole ==
                                                AccountRole.liquorstoreowner
                                            ? const Color(0xFF914852)
                                            : Colors.transparent,
                                        foregroundColor: Colors.white,
                                        side: BorderSide(
                                          color:
                                              selectedRole ==
                                                  AccountRole.liquorstoreowner
                                              ? Colors.transparent
                                              : const Color(0xFF914852),
                                          width: 2,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<RegisterBloc>().add(
                                          OnAccountRoleChanged(
                                            accountRole:
                                                AccountRole.liquorstoreowner,
                                          ),
                                        );
                                      },
                                      child: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Liquor Store Owner',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            selectedRole == AccountRole.supplier
                                            ? const Color(0xFF914852)
                                            : Colors.transparent,
                                        foregroundColor: Colors.white,
                                        side: BorderSide(
                                          color:
                                              selectedRole ==
                                                  AccountRole.supplier
                                              ? Colors.transparent
                                              : const Color(0xFF914852),
                                          width: 2,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<RegisterBloc>().add(
                                          OnAccountRoleChanged(
                                            accountRole: AccountRole.supplier,
                                          ),
                                        );
                                      },
                                      child: const Text('Supplier'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Account Info",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      context.read<RegisterBloc>().add(
                                        OnBusinessNameChanged(
                                          businessName: value,
                                        ),
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Business Name',
                                      prefixIcon: const Icon(Icons.business),
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.9,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocSelector<RegisterBloc, RegisterState, bool>(
                            selector: (state) => state.isFormValid,
                            builder: (context, isFormValid) {
                              return SizedBox(
                                height: 55,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: isFormValid
                                        ? const Color(0xFF2B000D)
                                        : Colors.grey,
                                  ),
                                  onPressed: isFormValid
                                      ? () {
                                          context.read<RegisterBloc>().add(
                                            Register(),
                                          );
                                        }
                                      : null,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

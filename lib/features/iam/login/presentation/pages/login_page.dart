import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/home/presentation/pages/home_page.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_event.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_state.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/password_recovery/presentation/pages/send_email_page.dart';
import 'package:stocksip/features/iam/register/presentation/pages/register_user_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/pages/choose_plan_screen.dart';
import 'package:stocksip/shared/presentation/widgets/stocksip_title.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          switch (state.status) {
            case Status.success:
              final tokenStorage = TokenStorage();
              final isFirst = await tokenStorage.isFirstLogin();
              
              if (isFirst) {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoosePlanScreen(
                        onContinue: (selectedPlan) async {
                          await tokenStorage.markLoginComplete();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              }
            case Status.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Unknown error'), behavior: SnackBarBehavior.floating, backgroundColor: Colors.red,),
              );
            default:
          }
        },
        child: Stack(
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
      
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: const AssetImage('assets/images/stocksip_logo.png'),
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
      
                const StockSipLogo(),
      
                const SizedBox(height: 20),
      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                          OnEmailChanged(email: value),
                        );
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                          OnPasswordChanged(password: value),
                        );
                      },
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.9),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isHidden ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _isHidden = !_isHidden);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
      
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SendEmailPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2B000D),
                      ),
                      onPressed: () {
                        context.read<LoginBloc>().add(Login());
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterUserPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      
            BlocSelector<LoginBloc, LoginState, bool>(
              selector: (state) => state.status == Status.loading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
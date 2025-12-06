import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_state.dart';
import 'package:stocksip/core/enums/status.dart';

class CongratsPage extends StatefulWidget {
  const CongratsPage({super.key});

  @override
  State<CongratsPage> createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    context.read<AccountBloc>().add(GetAccountStatus());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == Status.success && state.accountStatus != null) {
          final accountStatus = state.accountStatus.status;

          if (accountStatus == "Active") {
            Future.microtask(() => context.go('/home'));
          } else {
            Future.microtask(() => context.go('/plan-choose'));
          }
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Color(0xFF0D2818),
                Color(0xFF1E4D2B),
                Color(0xFF2E7D32),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          size: 100,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Text(
                          "Subscription Successful",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Your subscription has been activated successfully. Enjoy all premium features!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: BlocBuilder<AccountBloc, AccountState>(
                            builder: (context, state) {
                              final isActive =
                                  state.accountStatus.status == "Active";
                              final isInactive =
                                  state.accountStatus.status == "Inactive";

                              return ElevatedButton(
                                onPressed: (isActive || isInactive)
                                    ? () {
                                        if (isActive) {
                                          context.go(
                                            '/home',
                                          );
                                        } else if (isInactive) {
                                          context.go(
                                            '/choose-plan',
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (isActive || isInactive)
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

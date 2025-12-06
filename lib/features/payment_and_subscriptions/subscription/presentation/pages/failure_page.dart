import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_event.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_state.dart';
import 'package:stocksip/core/enums/status.dart';

class FailurePage extends StatefulWidget {
  const FailurePage({super.key});

  @override
  State<FailurePage> createState() => _FailurePageState();
}

class _FailurePageState extends State<FailurePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
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

          Future.delayed(const Duration(seconds: 8), () {
            if (!mounted) return;

            if (accountStatus == "Active") {
              context.go('/home');
            } else if (accountStatus == "Inactive") {
              context.go('/choose-plan');
            }
          });
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
                Color(0xFF2B000D),
                Color(0xFF5E2430),
                Color(0xFF914852),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _rotationAnimation
                        .drive(Tween<double>(begin: -5 / 360, end: 5 / 360)),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF6B35).withOpacity(0.2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.cancel,
                          size: 100,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Payment Failed",
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
                        colors: [
                          Color(0xFFFF6B35),
                          Color(0xFFFFA726),
                        ],
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
                          "Subscription Failed",
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
                          "Unfortunately, your subscription could not be processed. Please try again with different payment details.",
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
                                          context.go('/home');
                                        } else if (isInactive) {
                                          context.go('/choose-plan');
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (isActive || isInactive)
                                          ? const Color(0xFFFF6B35)
                                          : Colors.grey,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "Return",
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/pages/saleorder_page.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/pages/supplier_orders_page.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/bloc/profile_bloc.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/bloc/profile_event.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/bloc/profile_state.dart';

class OrdersRouterPage extends StatefulWidget {
  const OrdersRouterPage({super.key});

  @override
  State<OrdersRouterPage> createState() => _OrdersRouterPageState();
}

class _OrdersRouterPageState extends State<OrdersRouterPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ProfileBloc>();
      bloc.add(const LoadProfileEvent());
    });
  }

  void _navigate(String role) {
    if (_navigated || !mounted) return;
    final normalized = role.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    final isSupplier = normalized.contains('supplier');
    _navigated = true;
    final page = isSupplier ? const SupplierOrdersPage() : const SaleorderPage();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.assignedRole != curr.assignedRole,
        listener: (context, state) {
          final role = state.assignedRole.trim();
          if (role.isNotEmpty) {
            _navigate(role);
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
      backgroundColor: const Color(0xFFF4ECEC),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/order_management/salesorder/data/remote/services/saleorder_service.dart';
import 'package:stocksip/features/order_management/salesorder/data/repositories/salesorder_repository_impl.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_bloc.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_event.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_state.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/widgets/supplier_order_card.dart';

class SupplierOrdersPage extends StatefulWidget {
  const SupplierOrdersPage({super.key});

  @override
  State<SupplierOrdersPage> createState() => _SupplierOrdersPageState();
}

class _SupplierOrdersPageState extends State<SupplierOrdersPage> {
  late SaleorderBloc _saleorderBloc;

  @override
  void initState() {
    super.initState();

    final repo = SalesorderRepositoryImpl(
      service: SaleorderService(client: AuthHttpClient()),
    );
    _saleorderBloc = SaleorderBloc(repository: repo);
    
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final accountId = await TokenStorage().readAccountId();
      print('>>> [SupplierOrdersPage] AccountId retrieved: $accountId');
      _saleorderBloc.add(GetAllOrdersEvent(accountId: accountId));
    } catch (e) {
      print('>>> [SupplierOrdersPage] Error retrieving accountId: $e');
    }
  }

  @override
  void dispose() {
    _saleorderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleorderBloc>.value(
      value: _saleorderBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4ECEC),
        drawer: const DrawerNavigation(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: const Color(0xFFF4ECEC),
                pinned: true,
                expandedHeight: 100,
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF2B000D)),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                title: const Text(
                  'Orders',
                  style: TextStyle(
                    color: Color(0xFF2B000D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: SizedBox.shrink(),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    color: Color(0xFFB2737C),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<SaleorderBloc, SaleorderState>(
                    builder: (context, state) {
                      if (state.status == Status.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == Status.failure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Error: ${state.message}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  _loadOrders();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state.orders.isEmpty) {
                        return const Center(child: Text('No orders yet'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await _loadOrders();
                        },
                        child: ListView.separated(
                          itemCount: state.orders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final o = state.orders[index];
                            return SupplierOrderCard(
                              order: o,
                              bloc: context.read<SaleorderBloc>(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

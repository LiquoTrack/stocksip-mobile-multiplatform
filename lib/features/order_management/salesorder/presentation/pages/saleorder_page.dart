import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/features/order_management/salesorder/data/remote/services/saleorder_service.dart';
import 'package:stocksip/features/order_management/salesorder/data/repositories/salesorder_repository_impl.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_bloc.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_event.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_state.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/widgets/saleorder_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class SaleorderPage extends StatelessWidget {
  const SaleorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SalesorderRepositoryImpl(
      service: SaleorderService(client: AuthHttpClient()),
    );

    return BlocProvider<SaleorderBloc>(
      create: (_) => SaleorderBloc(repository: repo),
      child: Builder(
        builder: (ctx) {
          return Scaffold(
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
                          if (state.orders.isEmpty) {
                            return const Center(child: Text('No orders yet'));
                          }
                          return ListView.separated(
                            itemCount: state.orders.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final o = state.orders[index];
                              return SaleorderCard(order: o);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            floatingActionButton: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFB2737C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () {
                },
                child: const Icon(Icons.add, size: 28, color: Colors.white),
              ),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }
}

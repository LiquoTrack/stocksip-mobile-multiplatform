import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/services/adminpanel_service.dart';
import 'package:stocksip/features/iam/admin_panel/data/repositories/adminpanel_repository_impl.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_bloc.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_event.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_state.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/pages/new_user_page.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/widgets/user_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AdminPanelRepositoryImpl(
      service: AdminPanelService(client: AuthHttpClient()),
      tokenStorage: TokenStorage(),
    );

    return BlocProvider(
      create: (_) => AdminPanelBloc(repository: repo)..add(LoadSubUsers('All')),
      child: Builder(
        builder: (ctx) => Scaffold(
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
                'Administrative Panel',
                style: TextStyle(color: Color(0xFF2B000D), fontWeight: FontWeight.w600),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                  color: const Color(0xFFF4ECEC),
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFFE8D7D7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Users Capacity', style: TextStyle(color: Color(0xFF4C1F24))),
                            SizedBox(height: 6),
                          ],
                        ),
                        BlocBuilder<AdminPanelBloc, AdminPanelState>(
                          builder: (context, state) {
                            final total = state.groups.isNotEmpty ? state.groups.first.totalUsers : 0;
                            final max = state.groups.isNotEmpty ? state.groups.first.maxUsersAllowed : 0;
                            return Row(
                              children: [
                                Text(
                                  '$total/$max',
                                  style: const TextStyle(
                                    color: Color(0xFF2B000D),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('Available',
                                    style: TextStyle(
                                        color: Color(0xFF1F8F3A), fontWeight: FontWeight.w600)),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: BlocBuilder<AdminPanelBloc, AdminPanelState>(
                      builder: (context, state) {
                        if (state.status == AdminPanelState().status) {
                          return const SizedBox.shrink();
                        }
                        if (state.selectedRole.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        if (state.groups.isEmpty) {
                          return const Center(child: Text('No users found'));
                        }
                        final users = state.groups.expand((g) => g.users).toList();
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final u = users[index];
                            final isSelected = state.selectedIds.contains(u.userId);
                            return UserCard(
                              title: u.fullName,
                              subtitle: u.email,
                              roleLabel: u.role,
                              enabled: true,
                              selectable: state.selectionMode,
                              selected: isSelected,
                              onLongPress: () {
                                context.read<AdminPanelBloc>().add(ToggleSelectionMode(true));
                                context.read<AdminPanelBloc>().add(ToggleSelectUser(u.userId));
                              },
                              onTapSelect: () {
                                context.read<AdminPanelBloc>().add(ToggleSelectUser(u.userId));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C1F24),
        shape: const CircleBorder(),
        onPressed: () async {
          final accountId = await TokenStorage().readAccountId();
          await showModalBottomSheet(
            context: ctx,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => NewUserPage(
              repository: repo,
              accountId: accountId,
              parentContext: ctx,
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BlocBuilder<AdminPanelBloc, AdminPanelState>(
        builder: (context, state) {
          if (state.selectionMode && state.selectedIds.isNotEmpty) {
            return SafeArea(
              top: false,
              child: Container(
                height: 68,
                color: const Color(0xFFF4ECEC),
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: InkWell(
                    onTap: () => context.read<AdminPanelBloc>().add(DeleteSelected()),
                    borderRadius: BorderRadius.circular(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.delete_outline, color: Color(0xFF4C1F24)),
                        SizedBox(height: 4),
                        Text('Eliminar', style: TextStyle(color: Color(0xFF4C1F24), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return BottomAppBar(
            color: const Color(0xFFF4ECEC),
            elevation: 0,
            child: SafeArea(
              top: false,
              child: Container(
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE0D4D4), width: 1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) {
                    const Color selected = Color(0xFF4C1F24);
                    const Color unselected = Color(0xFFBDB5B5);

                    Widget navItem(IconData icon, String label, String key) {
                      final bool isActive = state.selectedRole == key;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.read<AdminPanelBloc>().add(LoadSubUsers(key)),
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(icon, size: 22, color: isActive ? selected : unselected),
                              const SizedBox(height: 2),
                              Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive ? selected : unselected,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        navItem(Icons.apps, 'All', 'All'),
                        navItem(Icons.admin_panel_settings, 'Admin', 'Admin'),
                        navItem(Icons.group, 'Employee', 'Employee'),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    ),
      ),
    );
  }
}

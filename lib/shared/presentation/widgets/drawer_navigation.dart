import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:stocksip/shared/presentation/widgets/navigation_item.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    Future.microtask(() {
      if (context.mounted) {
        context.go(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF2B000D),
        child: Column(
          children: [
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              color: const Color(0xFF2B000D),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Stock',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Sip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  NavigationTile(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => _navigate(context, '/home'),
                  ),
                  NavigationTile(
                    icon: Icons.warehouse,
                    title: 'Warehouse',
                    onTap: () => _navigate(context, '/warehouse'),
                  ),
                  NavigationTile(
                    icon: Icons.menu_book,
                    title: 'Care Guides',
                    onTap: () => _navigate(context, '/care-guides'),
                  ),
                  NavigationTile(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    onTap: () => _navigate(context, '/orders'),
                  ),
                  NavigationTile(
                    icon: Icons.inventory,
                    title: 'Products',
                    onTap: () => _navigate(context, '/storage'),
                  ),
                  NavigationTile(
                    icon: Icons.local_offer,
                    title: 'Catalog',
                    onTap: () => _navigate(context, '/catalog'),
                  ),
                  NavigationTile(
                    icon: Icons.subscriptions,
                    title: 'Subscriptions',
                    onTap: () => _navigate(context, '/subscriptions'),
                  ),
                  NavigationTile(
                    icon: Icons.shield,
                    title: 'Admin Panel',
                    onTap: () => _navigate(context, '/admin-panel'),
                  ),
                  NavigationTile(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () => _navigate(context, '/profile'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(const LogOut());
                  context.go('/sign-in');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

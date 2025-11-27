import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/home/presentation/pages/home_page.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_page.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/pages/storage_page.dart';
import 'package:stocksip/shared/presentation/widgets/navigation_item.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF2B000D),
        child: Column(
          children: [
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width *
                    0.04,
                vertical:
                    MediaQuery.of(context).size.height *
                    0.02,
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
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())),
                  ),
                  NavigationTile(
                    icon: Icons.warehouse,
                    title: 'Warehouse',
                    onTap: () => Navigator.pop(context),
                  ),
                  NavigationTile(
                    icon: Icons.menu_book,
                    title: 'Care Guides',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CareGuidePage(),
                        ),
                      );
                    },
                  ),
                  NavigationTile(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    onTap: () => Navigator.pop(context),
                  ),
                  NavigationTile(
                    icon: Icons.inventory,
                    title: 'Products',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StoragePage(
                        onNavigate: (String route) {
                        },
                        onLogout: () {
                        },
                      )),
                    ),
                  ),
                  NavigationTile(
                    icon: Icons.local_offer,
                    title: 'Catalog',
                    onTap: () => Navigator.pop(context),
                  ),
                  NavigationTile(
                    icon: Icons.subscriptions,
                    title: 'Subscriptions',
                    onTap: () => Navigator.pop(context),
                  ),
                  NavigationTile(
                    icon: Icons.shield,
                    title: 'Admin Panel',
                    onTap: () => Navigator.pop(context),
                  ),
                  NavigationTile(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () => Navigator.pop(context),
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  context.read<AuthBloc>().add(const LogOut());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
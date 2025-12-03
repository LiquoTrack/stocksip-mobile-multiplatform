import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onClose;
  final VoidCallback onLogout;

  const NavDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    required this.onClose,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF4ECEC),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4A1B2A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'StockSip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    isActive: currentRoute == 'home',
                    onTap: () {
                      onNavigate('home');
                      onClose();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Profile',
                    isActive: currentRoute == 'profile',
                    onTap: () {
                      onNavigate('profile');
                      onClose();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    isActive: currentRoute == 'orders',
                    onTap: () {
                      onNavigate('orders');
                      onClose();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.inventory,
                    title: 'Inventory',
                    isActive: currentRoute == 'inventory',
                    onTap: () {
                      onNavigate('inventory');
                      onClose();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    title: 'Payments',
                    isActive: currentRoute == 'payments',
                    onTap: () {
                      onNavigate('payments');
                      onClose();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    isActive: currentRoute == 'notifications',
                    onTap: () {
                      onNavigate('notifications');
                      onClose();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    onLogout();
                    onClose();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A1B2A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      color: isActive ? const Color(0xFFE8D4D4) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF4A1B2A) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF4A1B2A) : Colors.black,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

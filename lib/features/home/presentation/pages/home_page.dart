import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/pages/storage_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_page.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/presentation/pages/catalog_list_page.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/pages/adminpanel_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/pages/subscriptions_page.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _rocketController;
  late Animation<double> _rocketAnimation;

  late final List<ShortcutItem> shortcuts;

  @override
  void initState() {
    super.initState();
    
    _rocketController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rocketAnimation = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(parent: _rocketController, curve: Curves.easeInOut),
    );
    
    shortcuts = [
      ShortcutItem(
        title: 'New Product',
        description: 'How would you like to start?',
        buttonLabel: 'Add Product',
        imagePath: 'assets/images/vino1.png',
        color: const Color(0xFF8B4C5C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoragePage()),
        ),
      ),
      ShortcutItem(
        title: 'Add Catalogs',
        description: 'Organize your products',
        buttonLabel: 'Manage',
        imagePath: 'assets/images/nota1.png',
        color: const Color(0xFFB8838E),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CatalogListPage()),
        ),
      ),
      ShortcutItem(
        title: 'Admin Panel',
        description: 'Manage your users',
        buttonLabel: 'Add User',
        imagePath: 'assets/images/perfil1.png',
        color: const Color(0xFF5C1F2E),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPanelPage()),
        ),
      ),
      ShortcutItem(
        title: 'Care Guides',
        description: 'Learn best practices',
        buttonLabel: 'View Guides',
        imagePath: 'assets/images/guide1.png',
        color: const Color(0xFF8B4C5C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CareGuidePage()),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _rocketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerNavigation(),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFFF4ECEC),
        foregroundColor: const Color(0xFF4A1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      backgroundColor: const Color(0xFFF4ECEC),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8.0),
          // Banner Section
          _buildBannerCard(context),
          const SizedBox(height: 24.0),
          // Shortcuts Grid with Lazy Loading
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 14.0,
            mainAxisSpacing: 14.0,
            children: shortcuts.map((item) => _buildShortcutCard(item)).toList(),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5C1F2E),
              Color(0xFF8B4C5C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transform Your Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Unlock premium features to streamline your business operations and boost sales',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFE8B4BE),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionsPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF5C1F2E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Upgrade Now',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14.0),
                AnimatedBuilder(
                  animation: _rocketAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _rocketAnimation.value),
                      child: SizedBox(
                        width: 120.0,
                        height: 120.0,
                        child: Image.asset(
                          'assets/images/coheteespacial1.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard(ShortcutItem item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF5C1F2E),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                item.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: item.color.withOpacity(0.7),
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: item.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    item.buttonLabel,
                    style: const TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShortcutItem {
  final String title;
  final String description;
  final String buttonLabel;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  ShortcutItem({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });
}
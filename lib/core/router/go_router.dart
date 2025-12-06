import 'package:go_router/go_router.dart';
import 'package:stocksip/features/home/presentation/pages/home_page.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/pages/adminpanel_page.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:stocksip/features/iam/login/presentation/pages/splash_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_page.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/pages/storage_page.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/pages/warehouse_page.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/pages/supplier_orders_page.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/presentation/pages/catalog_list_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/pages/choose_plan_screen.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/pages/congrast_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/pages/failure_page.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/pages/subscriptions_page.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/payment-success',
      builder: (context, state) => const CongratsPage(),
    ),
    GoRoute(
      path: '/payment-failure',
      builder: (context, state) => const FailurePage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/choose-plan',
      builder: (context, state) => const ChoosePlanScreen(),
    ),
    GoRoute(
      path: '/warehouse',
      builder: (context, state) => const WarehousePage(),
    ),
    GoRoute(path: '/sign-in', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/admin-panel',
      builder: (context, state) => const AdminPanelPage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogListPage(),
    ),
    GoRoute(path: '/storage', builder: (context, state) => const StoragePage()),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const SupplierOrdersPage(),
    ),
    GoRoute(
      path: '/care-guides',
      builder: (context, state) => const CareGuidePage(),
    ),
    GoRoute(
      path: '/subscriptions',
      builder: (context, state) => const SubscriptionsPage(),
    ),
  ],
);

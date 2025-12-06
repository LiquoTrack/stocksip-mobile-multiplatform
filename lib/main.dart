import 'package:flutter/material.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/router/go_router.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/core/ui/theme.dart';
import 'package:stocksip/features/iam/login/data/repositories/auth_repository_impl.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/service/recovery_password_service.dart';
import 'package:stocksip/features/iam/password_recovery/data/repositories/recovery_password_repository_impl.dart';
import 'package:stocksip/features/iam/password_recovery/presentation/blocs/recovery_password_bloc.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/data/remote/inventory_service.dart';
import 'package:stocksip/features/inventory_management/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/blocs/inventory_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_detail/blocs/inventory_detail_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/brand_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_type_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/brand_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_type_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/remote/services/warehouse_service.dart';
import 'package:stocksip/features/inventory_management/warehouses/data/repositories/warehouses_repository_impl.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/data/remote/services/accounts_service.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/data/repositories/account_repository_impl.dart';
import 'package:stocksip/features/payment_and_subscriptions/accounts/presentation/bloc/account_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/remote/services/subscriptions_service.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:stocksip/features/payment_and_subscriptions/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:stocksip/features/profile_management/profiles/data/repositories/profile_repository_impl.dart';
import 'package:stocksip/features/profile_management/profiles/data/services/remote/profile_service.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/bloc/profile_bloc.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/data/repositories/catalog_repository_impl.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/data/services/remote/catalog_service.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/presentation/bloc/catalog_bloc.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/data/services/plan_service.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/data/repositories/plan_repository_impl.dart';
import 'package:stocksip/features/payment_and_subscriptions/plans/presentation/bloc/plan_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme(TextTheme());

    final authHttpClient = AuthHttpClient();
    final authService = AuthService();
    final tokenStorage = TokenStorage();
    final authRepository = AuthRepositoryImpl(
      service: authService,
      tokenStorage: tokenStorage,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(repository: authRepository),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(repository: authRepository),
        ),
        BlocProvider(
          create: (context) =>
              AuthBloc(tokenStorage: tokenStorage)..add(const AppStarted()),
        ),
        BlocProvider(
          create: (context) => StorageBloc(
            repository: ProductRepositoryImpl(
              service: ProductService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
            productTypeRepository: ProductTypeRepositoryImpl(
              productTypeService: ProductTypeService(),
            ),
            brandRepository: BrandRepositoryImpl(brandService: BrandService()),
          ),
        ),
        BlocProvider(
          create: (context) => CareguideBloc(
            repository: CareguideRepositoryImpl(
              service: CareguideService(client: authHttpClient),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => WarehouseBloc(
            repository: WarehousesRepositoryImpl(
              service: WarehouseService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            repository: ProfileRepositoryImpl(service: ProfileService()),
          ),
        ),
        BlocProvider(
          create: (context) => CatalogBloc(
            repository: CatalogRepositoryImpl(catalogService: CatalogService()),
          ),
        ),
        BlocProvider(
          create: (context) => RecoveryPasswordBloc(
            repository: RecoveryPasswordRepositoryImpl(
              service: RecoveryPasswordService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductDetailBloc(
            productRepository: ProductRepositoryImpl(
              service: ProductService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
        BlocProvider(
          create: (context) =>
              AuthBloc(tokenStorage: tokenStorage)..add(const AppStarted()),
        ),
        BlocProvider(
          create: (context) => PlanBloc(
            repository: PlanRepositoryImpl(
              apiService: PlanService(client: authHttpClient),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AccountBloc(
            repository: AccountRepositoryImpl(
              service: AccountsService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SubscriptionBloc(
            repository: SubscriptionRepositoryImpl(
              service: SubscriptionsService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => InventoryBloc(
            repository: InventoryRepositoryImpl(
              service: InventoryService(client: authHttpClient),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => InventoryDetailBloc(
            inventoryRepository: InventoryRepositoryImpl(
              service: InventoryService(client: authHttpClient),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => InventoryAdditionBloc(
            inventoryRepository: InventoryRepositoryImpl(
              service: InventoryService(client: authHttpClient),
            ),
            productRepository: ProductRepositoryImpl(
              service: ProductService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => InventorySubtrackBloc(
            inventoryRepository: InventoryRepositoryImpl(
              service: InventoryService(client: authHttpClient),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => InventoryTransferBloc(
            inventoryRepository: InventoryRepositoryImpl(
              service: InventoryService(client: authHttpClient),
            ),
            warehouseRepository: WarehousesRepositoryImpl(
              service: WarehouseService(client: authHttpClient),
              tokenStorage: tokenStorage,
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        routerConfig: appRouter,
      ),
    );
  }
}

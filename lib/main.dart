import 'package:flutter/material.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/core/ui/theme.dart';
import 'package:stocksip/features/iam/login/data/repositories/auth_repository_impl.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/pages/splash_page.dart';
import 'package:stocksip/features/iam/password_recovery/data/remote/service/recovery_password_service.dart';
import 'package:stocksip/features/iam/password_recovery/data/repositories/recovery_password_repository_impl.dart';
import 'package:stocksip/features/iam/password_recovery/presentation/blocs/recovery_password_bloc.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
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
import 'package:stocksip/features/profile_management/profiles/data/repositories/profile_repository_impl.dart';
import 'package:stocksip/features/profile_management/profiles/data/services/remote/profile_service.dart';
import 'package:stocksip/features/profile_management/profiles/presentation/bloc/profile_bloc.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/data/repositories/catalog_repository_impl.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/data/services/remote/catalog_service.dart';
import 'package:stocksip/features/ordering_procurement/catalogs/presentation/bloc/catalog_bloc.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const SplashPage(),
      ),
    );
  }
}

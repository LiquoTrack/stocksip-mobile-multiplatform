import 'package:flutter/material.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/core/ui/theme.dart';
import 'package:stocksip/features/iam/login/data/repositories/auth_repository_impl.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/pages/splash_page.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
import 'package:stocksip/features/inventorymanagement/storage/data/services/remote/product_service.dart';
import 'package:stocksip/features/inventorymanagement/storage/presentation/storage/blocs/storage_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    MaterialTheme theme = MaterialTheme(TextTheme());

    final authService = AuthService();
    final tokenStorage = TokenStorage();
    final authRepository = AuthRepositoryImpl(
      service: authService,
      tokenStorage: tokenStorage,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(repository: authRepository)),
        BlocProvider(create: (context) => RegisterBloc(repository: authRepository)),
        BlocProvider(create: (context) => AuthBloc(tokenStorage: tokenStorage)..add(const AppStarted())),
        BlocProvider(create: (context) => StorageBloc(service: ProductService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const SplashPage()
      ),
    );
  }
}

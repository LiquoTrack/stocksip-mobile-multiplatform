import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocksip/core/ui/theme.dart';
import 'package:stocksip/features/iam/login/data/services/remote/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';
import 'package:stocksip/features/iam/register/presentation/bloc/register_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/data/remote/services/product_service.dart';
import 'package:stocksip/features/inventory_management/storage/data/repositories/product_repository_impl.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    MaterialTheme theme = MaterialTheme(TextTheme());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(service: AuthService(), storage: FlutterSecureStorage())),
        BlocProvider(create: (context) => RegisterBloc(service: AuthService())),
        BlocProvider(create: (context) => StorageBloc(repository: ProductRepositoryImpl(service: ProductService())))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: LoginPage()
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stocksip/core/ui/theme.dart';
import 'package:stocksip/features/iam/login/data/auth_service.dart';
import 'package:stocksip/features/iam/login/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/iam/login/presentation/blocs/login_bloc.dart';

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
        BlocProvider(create: (context) => LoginBloc(service: AuthService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: Scaffold(          
          body: LoginPage()
        ),
      ),
    );
  }
}

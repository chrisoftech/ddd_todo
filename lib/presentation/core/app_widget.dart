import 'package:auto_route/auto_route.dart';
import 'package:ddd_todo/a_core/di/injection.dart';
import 'package:ddd_todo/application/auth/auth_bloc.dart';
import 'package:ddd_todo/presentation/route/router.gr.dart';
import 'package:ddd_todo/presentation/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.appStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.indigo,
          accentColor: Colors.orange,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        builder: ExtendedNavigator(router: Router()),
      ),
    );
  }
}

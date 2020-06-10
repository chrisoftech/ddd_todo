// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:ddd_todo/infrastructure/core/injectable_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ddd_todo/infrastructure/auth/auth_facade.dart';
import 'package:ddd_todo/domain/auth/i_auth_facade.dart';
import 'package:ddd_todo/application/sign_in_form/sign_in_form_bloc.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final injectableModule = _$InjectableModule();
  g.registerFactory<FirebaseAuth>(() => injectableModule.firebaseAuth);
  g.registerFactory<GoogleSignIn>(() => injectableModule.googleSignIn);
  g.registerLazySingleton<IAuthFacade>(
      () => AuthFacade(g<FirebaseAuth>(), g<GoogleSignIn>()));
  g.registerFactory<SignInFormBloc>(() => SignInFormBloc(g<IAuthFacade>()));
}

class _$InjectableModule extends InjectableModule {}

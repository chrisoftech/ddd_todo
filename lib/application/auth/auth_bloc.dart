import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ddd_todo/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade);

  @override
  AuthState get initialState => const AuthState.initial();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield* event.map(
      appStarted: (_) async* {
        final _userOption = await _authFacade.getSignedInUser();

        yield _userOption.fold(
          () => const AuthState.unauthenticated(),
          (_) => const AuthState.authenticated(),
        );
      },
      signedOut: (_) async* {
        await _authFacade.signout();
        yield const AuthState.unauthenticated();
      },
    );
  }
}

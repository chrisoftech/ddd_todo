import 'package:ddd_todo/a_core/exceptions/errors.dart';
import 'package:ddd_todo/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_todo/domain/auth/i_auth_facade.dart';
import 'package:ddd_todo/domain/auth/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthFacade(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {@required EmailAddress emailAddress,
      @required Password password}) async {
    final _emailAddressStr = emailAddress.getOrCrash();
    final _passwordStr = password.getOrCrash();

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailAddressStr, password: _passwordStr);

      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {@required EmailAddress emailAddress,
      @required Password password}) async {
    final _emailAddressStr = emailAddress.getOrCrash();
    final _passwordStr = password.getOrCrash();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailAddressStr, password: _passwordStr);

      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD' ||
          e.code == 'ERROR_USER_NOT_FOUND') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final _googleUser = await _googleSignIn.signIn();

      if (_googleUser == null) {
        return left(AuthFailure.cancelledByUser());
      }

      final _googleAuthentication = await _googleUser.authentication;

      final _authCredential = GoogleAuthProvider.getCredential(
        idToken: _googleAuthentication.idToken,
        accessToken: _googleAuthentication.accessToken,
      );

      await _firebaseAuth.signInWithCredential(_authCredential);

      return right(unit);
    } on PlatformException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }
}


import 'package:ddd_todo/domain/auth/user.dart';
import 'package:ddd_todo/domain/core/validators/value_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseUserDomainX on FirebaseUser {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
} 
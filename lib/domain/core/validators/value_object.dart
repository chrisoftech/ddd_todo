import 'package:dartz/dartz.dart';
import 'package:ddd_todo/domain/core/exceptions/errors.dart';
import 'package:ddd_todo/domain/core/failures/failures.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid_type/uuid_type.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold((failure) => left(failure), (_) => right(unit));
  }

  bool isValid() => value.isRight();

  /// throws [UnexpectedValueError] containing the value failure
  T getOrCrash() {
    // id = identity - same as writing (right) => right
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject(value: $value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId() {
    return UniqueId._(
      right(uuid.v4()),
    );
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    assert(uniqueId != null, 'uniqueId cannot be null');
    return UniqueId._(
      right(uniqueId),
    );
  }

  const UniqueId._(this.value);
}

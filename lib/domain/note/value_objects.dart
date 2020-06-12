import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:ddd_todo/domain/core/failures/failures.dart';
import 'package:ddd_todo/domain/core/validators/value_object.dart';
import 'package:ddd_todo/domain/core/validators/value_transformers.dart';
import 'package:ddd_todo/domain/core/validators/value_validators.dart';
import 'package:kt_dart/collection.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory NoteBody(String input) {
    assert(input != null, 'Note body cannot be null');
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._(this.value);
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 30;

  factory TodoName(String input) {
    assert(input != null, 'Todo name cannot be null');
    return TodoName._(
      validateMaxStringLength(input, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateMultilineString),
    );
  }

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor(Color input) {
    return NoteColor._(
      right(makeColorOpaque(input)),
    );
  }

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<KtList> {
  @override
  final Either<ValueFailure<KtList>, KtList> value;

  static const maxLength = 3;

  factory List3(KtList<T> input) {
    assert(input != null, 'List can only be 3 in value');
    return List3._(
      validateListTooLong(input, maxLength),
    );
  }

  const List3._(this.value);

  int length() {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    return length() == maxLength;
  }
}

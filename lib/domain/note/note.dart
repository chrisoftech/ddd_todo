import 'package:dartz/dartz.dart';
import 'package:ddd_todo/domain/core/failures/failures.dart';
import 'package:ddd_todo/domain/core/validators/value_object.dart';
import 'package:ddd_todo/domain/note/todo_item.dart';
import 'package:ddd_todo/domain/note/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId uniqueId,
    @required NoteBody body,
    @required NoteColor color,
    @required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        uniqueId: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors.first),
        todos: List3<TodoItem>(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              // Getting the failureOption from the TodoItem ENTITY - Not a failureOrUnit from a VALUE OBJECT
              .map((todoItem) => (todoItem as TodoItem).failureOption)
              .filter((o) => o.isSome())
              // If we can't get the 0th element, the list is empty. In this case, it is valid
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (failure) => left(failure)),
        )
        .fold((failure) => some(failure), (_) => none());
  }
}

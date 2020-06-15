import 'package:dartz/dartz.dart';
import 'package:ddd_todo/domain/core/failures/failures.dart';
import 'package:ddd_todo/domain/core/validators/value_object.dart';
import 'package:ddd_todo/domain/note/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item.freezed.dart';

@freezed
abstract class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    @required UniqueId uniqueId,
    @required TodoName name,
    @required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        uniqueId: UniqueId(),
        name: TodoName(''),
        done: false,
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((failure) => some(failure), (_) => none());
  }
}

import 'package:ddd_todo/a_core/exceptions/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    final _explanation =
        'Encountered a ValueFailure at an unrecoverable point. Terminating.';
    return Error.safeToString('$_explanation Failure was $valueFailure');
  }
}

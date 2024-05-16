import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  final int code;
  final StackTrace? stackTrace;

  Failure(
    this.message,
    this.code, {
    this.stackTrace,
  });
}

typedef FailureOrOk<T> = Future<Either<Failure, T>>;

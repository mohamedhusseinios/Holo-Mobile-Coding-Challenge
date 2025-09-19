import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

typedef ResultFuture<T> = Future<Result<T>>;

typedef ResultStream<T> = Stream<Result<T>>;

sealed class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is FailureResult<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    }
    if (this is FailureResult<T>) {
      return failure((this as FailureResult<T>).failure);
    }
    throw StateError('Unhandled result state: $runtimeType');
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

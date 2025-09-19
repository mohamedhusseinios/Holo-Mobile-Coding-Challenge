import 'result.dart';

abstract interface class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}

class NoParams {
  const NoParams();
}

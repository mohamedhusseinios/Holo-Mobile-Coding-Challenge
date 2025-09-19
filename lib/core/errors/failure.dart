import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}

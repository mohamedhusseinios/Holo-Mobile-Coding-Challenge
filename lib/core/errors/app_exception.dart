class AppException implements Exception {
  AppException({required this.message, this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
}

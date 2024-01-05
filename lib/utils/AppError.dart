class AppError implements Exception {
  final String message;
  final num? statusCode;
  final StackTrace stackTrace;

  AppError({required this.message, this.statusCode})
      : stackTrace = StackTrace.current {
    print(toString());
  }

  @override
  String toString() =>
      'AppError${statusCode != null ? "(statusCode:${statusCode})" : ""}:$message\n${stackTrace}';
}

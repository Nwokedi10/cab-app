class Failure implements Exception {
  final String? message;
  final Exception? exception;
  final StackTrace stackTrace;

  Failure({this.message, this.exception, StackTrace? stackTrace})
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return '''| Failure | --
    Message: $message
    StackTrace: $stackTrace
    Exception: $exception''';
  }
}

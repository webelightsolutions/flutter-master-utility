part of 'api_service.dart';

class ApiException {
  String message;
  Object? exception;
  int? statusCode;

  StackTrace? stackTrace;

  Response<dynamic>? response;

  ApiException({
    required this.message,
    this.exception,
    this.statusCode = 0,
    this.stackTrace,
    this.response,
  });
}

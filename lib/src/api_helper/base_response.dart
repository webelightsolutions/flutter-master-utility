part of 'api_service.dart';

class BaseResponse<T> {
  BaseResponse({
    required this.hasError,
    required this.data,
    this.message,
    this.statusCode,
  });

  bool hasError = false;
  String? message;
  int? statusCode;
  T data;
  String? refreshToken;
}

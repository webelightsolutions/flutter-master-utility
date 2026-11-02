import 'package:dio/dio.dart';
import 'package:master_utility/src/log/log.dart';

class APIResponse<T> {
  static const String _setCookieKey = "Set-Cookie";
  static const String _messageKey = "message";
  static const String _errorKey = "error";

  APIResponse({
    required this.hasError,
    this.message,
    this.statusCode,
    this.data,
  });

  APIResponse.fromJson(
    Response<dynamic>? response, {
    Function(T)? create,
  }) {
    final int statusCode = response!.statusCode!;
    hasError = statusCode < 200 || statusCode > 299;

    try {
      if (response.data[_messageKey] != null) {
        message = response.data?[_messageKey];
      } else if (response.data[_errorKey] != null) {
        message = response.data?[_errorKey];
      } else {
        message = response.statusMessage;
      }
    } catch (messageParseError) {
      // Body isn't a map or the message isn't a String.
      message = response.statusMessage;
    }

    this.statusCode = statusCode;
    data = (response.data != null && create != null) ? create(response.data) : null;
    try {
      if (response.headers[_setCookieKey] != null) {
        refreshToken = response.headers[_setCookieKey]?.first ?? '';
        cookies = response.headers[_setCookieKey] ?? [];
      }
    } catch (cookieParseError) {
      LogHelper.logError(cookieParseError, stackTrace: StackTrace.current);
    }
  }

  factory APIResponse.custom({required String message}) {
    return APIResponse<T>(message: message, hasError: true);
  }

  bool hasError = false;
  String? message;
  int? statusCode;
  T? data;
  String? refreshToken;
  List<String>? cookies;
}

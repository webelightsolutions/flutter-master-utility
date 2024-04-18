part of 'api_service.dart';

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
    if (response!.statusCode! >= 200 && response.statusCode! <= 299) {
      hasError = false;
    } else {
      hasError = true;
    }
    try {
      if (response.data[_messageKey] != null) {
        message = response.data?[_messageKey];
      } else if (response.data[_errorKey] != null) {
        message = response.data?[_errorKey];
      } else {
        message = response.statusMessage;
      }
    } catch (e) {
      message = response.statusMessage;
    }

    statusCode = response.statusCode;
    data = (response.data != null && create != null)
        ? create(
            response.data,
          )
        : null;
    try {
      if (response.headers[_setCookieKey] != null) {
        refreshToken = response.headers[_setCookieKey]?.first ?? '';
        cookies = response.headers[_setCookieKey] ?? [];
      }
    } catch (e) {
      LogHelper.logError(e, stackTrace: StackTrace.current);
    }
  }

  factory APIResponse.custom({required String message}) {
    return APIResponse<T>(message: message, hasError: true);
  }

  bool hasError = false;
  String? message;
  int? statusCode;
  dynamic data;
  String? refreshToken;
  List<String>? cookies;
}

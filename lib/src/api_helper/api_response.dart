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
      final isMap = response.data is Map<String, dynamic>;

      if (isMap && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        final hasMessageKey = responseData.containsKey(_messageKey) && responseData[_messageKey] != null;
        final hasErrorKey = responseData.containsKey(_errorKey) && responseData[_errorKey] != null;

        if (hasMessageKey) {
          message = responseData[_messageKey];
        } else if (hasErrorKey) {
          message = responseData[_errorKey];
        } else {
          message = response.statusMessage;
        }
      } else {
        message = response.statusMessage;
      }
    } catch (e) {
      message = response.statusMessage;
    }

    statusCode = response.statusCode;
    data = (response.data != null && create != null) ? create(response.data) : null;
    try {
      final hasCookiesKey = response.headers.map.keys.contains(_setCookieKey);
      if (hasCookiesKey && response.headers[_setCookieKey] != null) {
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
  T? data;
  String? refreshToken;
  List<String>? cookies;
}

import 'package:dio/dio.dart';

/// User-facing error messages. Apps may reassign these (e.g. for translation), so they're read at call time.
class APIConstError {
  static String somethingWentWrong = 'Something went wrong.';
  static String noInternetConnection = 'No internet connection.';
  static String connectionFailed = 'Connection to API server failed due to internet connection';
  static String internalServerError = 'Internal Server Error';
  static String sendTimeout = 'Send timeout in connection with API server';
  static String receiveTimeout = 'Receive timeout in connection with API server';
  static String connectionTimeout = 'Connection timeout with API server';
  static String requestCancelled = 'Request to API server was cancelled';
  static String loginFailed = 'Login Failed';

  static String invalidStatusCode({required int statusCode}) => 'Received invalid status code: $statusCode';

  // Old names: same storage as the new ones, so setting either changes both.

  @Deprecated('Use somethingWentWrong instead.')
  static String get kSomethingWentWrong => somethingWentWrong;
  @Deprecated('Use somethingWentWrong instead.')
  static set kSomethingWentWrong(String message) => somethingWentWrong = message;

  @Deprecated('Use noInternetConnection instead.')
  static String get kNoInternetConnection => noInternetConnection;
  @Deprecated('Use noInternetConnection instead.')
  static set kNoInternetConnection(String message) => noInternetConnection = message;

  @Deprecated('Use connectionFailed instead.')
  static String get kNoInternetConnection2 => connectionFailed;
  @Deprecated('Use connectionFailed instead.')
  static set kNoInternetConnection2(String message) => connectionFailed = message;

  @Deprecated('Use internalServerError instead.')
  static String get kInternalServerError => internalServerError;
  @Deprecated('Use internalServerError instead.')
  static set kInternalServerError(String message) => internalServerError = message;

  @Deprecated('Use sendTimeout instead.')
  static String get kSendTimeOUT => sendTimeout;
  @Deprecated('Use sendTimeout instead.')
  static set kSendTimeOUT(String message) => sendTimeout = message;

  @Deprecated('Use receiveTimeout instead.')
  static String get kReceiveTimeOut => receiveTimeout;
  @Deprecated('Use receiveTimeout instead.')
  static set kReceiveTimeOut(String message) => receiveTimeout = message;

  @Deprecated('Use connectionTimeout instead.')
  static String get kTimeOut => connectionTimeout;
  @Deprecated('Use connectionTimeout instead.')
  static set kTimeOut(String message) => connectionTimeout = message;

  @Deprecated('Use requestCancelled instead.')
  static String get kCancelled => requestCancelled;
  @Deprecated('Use requestCancelled instead.')
  static set kCancelled(String message) => requestCancelled = message;

  @Deprecated('Use loginFailed instead.')
  static String get errorLoginFailed => loginFailed;
  @Deprecated('Use loginFailed instead.')
  static set errorLoginFailed(String message) => loginFailed = message;

  @Deprecated('Use invalidStatusCode instead.')
  static String kInvalidStatusCode({required int statusCode}) => invalidStatusCode(statusCode: statusCode);
}

class ErrorHandler {
  static ErrorHandler instance = ErrorHandler();

  /// Message for a [DioException], based only on its type.
  String messageFor(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return APIConstError.connectionTimeout;

      case DioExceptionType.sendTimeout:
        return APIConstError.sendTimeout;

      case DioExceptionType.receiveTimeout:
        return APIConstError.receiveTimeout;

      case DioExceptionType.badCertificate:
        return APIConstError.somethingWentWrong;

      case DioExceptionType.badResponse:
        return APIConstError.invalidStatusCode(
          statusCode: dioException.response?.statusCode ?? 0,
        );

      case DioExceptionType.cancel:
        return APIConstError.requestCancelled;

      case DioExceptionType.connectionError:
        return APIConstError.connectionFailed;

      case DioExceptionType.unknown:
        return APIConstError.somethingWentWrong;
    }
  }

  @Deprecated('Use messageFor instead.')
  String getDioError(DioException dioException) => messageFor(dioException);
}

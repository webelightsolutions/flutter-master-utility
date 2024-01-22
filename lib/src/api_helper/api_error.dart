part of 'api_service.dart';

class APIConstError {
  static String kSomethingWentWrong = 'Something went wrong.';
  static String kNoInternetConnection = 'No internet connection.';
  static String kNoInternetConnection2 =
      'Connection to API server failed due to internet connection';
  static String kInternalServerError = 'Internal Server Error';
  static String kSendTimeOUT = 'Send timeout in connection with API server';
  static String kReceiveTimeOut =
      'Receive timeout in connection with API server';
  static String kTimeOut = 'Connection timeout with API server';
  static String kCancelled = 'Request to API server was cancelled';
  static String errorLoginFailed = 'Login Failed';

  static String kInvalidStatusCode({required int statusCode}) =>
      'Received invalid status code: $statusCode';
}

class ErrorHandler {
  static ErrorHandler instance = ErrorHandler();

  String getDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return APIConstError.kTimeOut;

      case DioExceptionType.sendTimeout:
        return APIConstError.kSendTimeOUT;

      case DioExceptionType.receiveTimeout:
        return APIConstError.kReceiveTimeOut;

      case DioExceptionType.badCertificate:
        return APIConstError.kSomethingWentWrong;

      case DioExceptionType.badResponse:
        return APIConstError.kInvalidStatusCode(
          statusCode: error.response?.statusCode ?? 0,
        );

      case DioExceptionType.cancel:
        return APIConstError.kCancelled;

      case DioExceptionType.connectionError:
        return APIConstError.kNoInternetConnection2;

      case DioExceptionType.unknown:
        return APIConstError.kSomethingWentWrong;
    }
  }
}

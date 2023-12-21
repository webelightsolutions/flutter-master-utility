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

  String getDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return APIConstError.kCancelled;

      case DioErrorType.connectTimeout:
        return APIConstError.kTimeOut;

      case DioErrorType.other:
        return APIConstError.kNoInternetConnection2;

      case DioErrorType.receiveTimeout:
        return APIConstError.kReceiveTimeOut;

      case DioErrorType.response:
        return APIConstError.kInvalidStatusCode(
          statusCode: error.response?.statusCode ?? 0,
        );

      case DioErrorType.sendTimeout:
        return APIConstError.kSendTimeOUT;

      default:
        return APIConstError.kSomethingWentWrong;
    }
  }
}

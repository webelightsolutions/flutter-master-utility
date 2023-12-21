part of 'api_service.dart';

class APIResponse<T> {
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
      if (response.data['message'] != null) {
        message = response.data?['message'];
      } else if (response.data['error'] != null) {
        message = response.data?['error'];
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
  }

  factory APIResponse.custom({required String message}) {
    return APIResponse<T>(message: message, hasError: true);
  }

  bool hasError = false;
  String? message;
  int? statusCode;
  dynamic data;
}

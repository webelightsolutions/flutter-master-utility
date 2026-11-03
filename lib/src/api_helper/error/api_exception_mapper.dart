import 'dart:io';

import 'package:dio/dio.dart';
import 'package:master_utility/src/api_helper/error/api_error_messages.dart';
import 'package:master_utility/src/api_helper/error/api_error_model.dart';
import 'package:master_utility/src/api_helper/response/api_exception.dart';
import 'package:master_utility/src/api_helper/response/api_response.dart';
import 'package:master_utility/src/api_helper/type_defs.dart';

/// Turns a failed Dio call into the [ApiException] that `APIService` returns.
class ApiExceptionMapper {
  const ApiExceptionMapper({this.customErrorMapper});

  /// The app's own mapper from `dioClient.customErrorMapper`. When set, it decides every message.
  final CustomErrorMapper<dynamic>? customErrorMapper;

  ApiException map(DioException dioException) {
    final Response<dynamic>? errorResponse = dioException.response;
    final String message = errorResponse == null
        ? ErrorHandler.instance.messageFor(dioException)
        : _messageFromResponse(errorResponse);

    return ApiException(
      message: message,
      exception: dioException,
      statusCode: errorResponse?.statusCode,
      stackTrace: dioException.stackTrace,
    );
  }

  String _messageFromResponse(Response<dynamic> errorResponse) {
    if (customErrorMapper != null) {
      return customErrorMapper!(errorResponse).message ?? '';
    }

    if (errorResponse.statusCode == HttpStatus.unprocessableEntity) {
      final dynamic responseBody = errorResponse.data;
      // Throws when the body isn't a map: known bug D3, fixed in its own commit.
      final bool hasValidationDetails = responseBody['detail']?.isNotEmpty ?? false;
      if (hasValidationDetails) {
        return joinValidationMessages(ApiErrorModel.fromJson(responseBody).detail);
      }
    }

    if (errorResponse.statusCode == HttpStatus.internalServerError) {
      return errorResponse.statusMessage ?? '';
    }

    return APIResponse<dynamic>.fromJson(errorResponse).message ?? '';
  }

  /// Unique validation messages joined by ", ".
  static String joinValidationMessages(List<ErrorDetails>? errorDetails) {
    final Set<String> uniqueMessages = <String>{};
    final StringBuffer joinedMessages = StringBuffer();

    for (final ErrorDetails errorDetail in errorDetails ?? <ErrorDetails>[]) {
      final String? message = errorDetail.msg;
      if (message != null && uniqueMessages.add(message)) {
        joinedMessages.write('$message, ');
      }
    }

    return joinedMessages.toString().trim().replaceAll(RegExp(r',\s*$'), '');
  }
}

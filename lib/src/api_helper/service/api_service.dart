import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:master_utility/src/api_helper/client/dio_client.dart';
import 'package:master_utility/src/api_helper/error/api_error_messages.dart';
import 'package:master_utility/src/api_helper/error/api_error_model.dart';
import 'package:master_utility/src/api_helper/error/api_exception_mapper.dart';
import 'package:master_utility/src/api_helper/request/api_request.dart';
import 'package:master_utility/src/api_helper/request/method_type.dart';
import 'package:master_utility/src/api_helper/response/api_exception.dart';
import 'package:master_utility/src/api_helper/type_defs.dart';

class APIService {
  Future<Either<ApiException, T>> getResponseWithMapper<T>(
    APIRequest request, {
    FormData? formData,

    /// Use this for if response is JsonObject
    final JsonMapper<T>? jsonMapper,

    /// Use this for if response is JsonArray
    final ListJsonMapper<T>? listJsonMapper,
  }) async {
    assert(jsonMapper == null || listJsonMapper == null, 'Can not provide both json mapper!');
    try {
      final Response<dynamic> response = await _send(request, formData);
      final dynamic responseBody = response.data;

      if (responseBody is Map<String, dynamic> && jsonMapper != null) {
        return right(await compute(jsonMapper, responseBody));
      }
      if (responseBody is List<dynamic> && listJsonMapper != null) {
        return right(await compute(listJsonMapper, responseBody));
      }
      return right(responseBody);
    } on DioException catch (dioException) {
      final ApiExceptionMapper exceptionMapper = ApiExceptionMapper(customErrorMapper: dioClient.customErrorMapper);
      return left(exceptionMapper.map(dioException));
    } catch (error, stackTrace) {
      return left(
        ApiException(
          message: APIConstError.somethingWentWrong,
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Unique validation messages joined by ", ".
  String joinValidationMessages(List<ErrorDetails>? errorDetails) =>
      ApiExceptionMapper.joinValidationMessages(errorDetails);

  @Deprecated('Use joinValidationMessages instead.')
  String setErrorData(List<ErrorDetails>? errorDetails) => joinValidationMessages(errorDetails);

  Future<Response<dynamic>> _send(APIRequest request, FormData? formData) {
    final Dio dio = dioClient.getDioClient(
      isAuth: request.requiresAuth,
      callback: request.onError,
      showHttpLogging: request.showHttpLogging,
      showCurlLogging: request.showCurlLogging,
    );

    return dio.request<dynamic>(
      request.url,
      data: request._bodyFor(formData),
      queryParameters: request.queryParams,
      cancelToken: request.cancelToken,
      onSendProgress: request._sendProgressCallback,
      onReceiveProgress: request._receiveProgressCallback,
      options: Options(method: request.methodType.name, headers: request.headers),
    );
  }
}

/// How an [APIRequest] maps onto a Dio call. Each method keeps its own body and progress rules.
extension _DioRequestMapping on APIRequest {
  Object? _bodyFor(FormData? formData) {
    switch (methodType) {
      case MethodType.GET:
        return null;
      case MethodType.POST:
        return formData ?? bodyList ?? body;
      case MethodType.PATCH:
      case MethodType.PUT:
        return formData ?? body;
      case MethodType.DELETE:
        return formData ?? body ?? bodyList;
    }
  }

  /// GET and DELETE don't report upload progress.
  ProgressCallback? get _sendProgressCallback =>
      methodType == MethodType.GET || methodType == MethodType.DELETE ? null : onSendProgress;

  /// DELETE doesn't report download progress.
  ProgressCallback? get _receiveProgressCallback => methodType == MethodType.DELETE ? null : onReceiveProgress;
}

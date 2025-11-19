// Dart imports:
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/api_helper/api_error_model.dart';

part 'api_error.dart';
part 'api_exception.dart';
part 'api_helper.dart';
part 'api_request.dart';
part 'api_response.dart';

class APIService {
  Future<Response<dynamic>> _getResponse({
    required APIRequest request,
    FormData? formData,
  }) async {
    Dio dio = dioClient.getDioClient(
      isAuth: request.isAuthorization,
      callback: request.onError,
    );
    switch (request.methodType) {
      case MethodType.GET:
        return dio.get(
          request.url,
          options: Options(
            headers: request.header,
          ),
          queryParameters: request.queryParams,
          cancelToken: request.cancelToken,
          onReceiveProgress: request.onReceiveProgress,
        );

      case MethodType.POST:
        return dio.post(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.paramList ?? request.params,
          queryParameters: request.queryParams,
          cancelToken: request.cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onSendProgress,
        );

      case MethodType.PATCH:
        return dio.patch(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params,
          queryParameters: request.queryParams,
          cancelToken: request.cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onSendProgress,
        );

      case MethodType.PUT:
        return dio.put(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params,
          queryParameters: request.queryParams,
          cancelToken: request.cancelToken,
          onReceiveProgress: request.onReceiveProgress,
          onSendProgress: request.onSendProgress,
        );

      case MethodType.DELETE:
        return dio.delete(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params ?? request.paramList,
          queryParameters: request.queryParams,
          cancelToken: request.cancelToken,
        );
    }
  }

  Future<APIResponse<dynamic>> getApiResponse(
    APIRequest request, {
    Function(dynamic)? apiResponse,
    FormData? formData,
  }) async {
    try {
      final Response<dynamic>? response = await _getResponse(request: request, formData: formData);

      if (response != null) {
        if (request.mixPanelEventModel != null) {
          MixPanelService.instance.trackEvent(
            eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
            data: request.mixPanelEventModel?.successData,
          );
        }
        if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
          MixPanelService.instance.trackEvent(
            eventName: _removeQueryParams(request.url),
            data: response.data,
          );
        }
        return APIResponse<dynamic>.fromJson(
          response,
          create: apiResponse,
        );
      }
      return APIResponse<dynamic>.custom(
        message: APIConstError.kSomethingWentWrong,
      );
    } on DioException catch (e) {
      if (request.mixPanelEventModel != null) {
        MixPanelService.instance.trackEvent(
          eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
          data: request.mixPanelEventModel?.errorData,
        );
      }
      if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
        MixPanelService.instance.trackEvent(
          eventName: _removeQueryParams(request.url),
          data: e.response?.data,
        );
      }
      if (e.response != null) {
        final APIResponse<dynamic> errorModel;
        if (e.response?.statusCode == 422) {
          if (e.response?.data['detail']?.isNotEmpty ?? false) {
            ApiErrorModel errorResponse = ApiErrorModel.fromJson(e.response?.data);
            String errorMessage = setErrorData(errorResponse.detail);

            debugPrint(errorMessage);

            Response<dynamic> responseData = Response(
              requestOptions: RequestOptions(path: ""),
              data: {
                "hasError": true,
                "message": errorMessage,
                "statusCode": e.response?.statusCode,
                "data": e.response?.data,
              },
              statusCode: e.response?.statusCode,
              statusMessage: errorMessage,
            );

            errorModel = APIResponse<dynamic>.fromJson(
              responseData,
              create: apiResponse,
            );
          } else {
            errorModel = APIResponse<dynamic>.fromJson(
              e.response!,
              create: apiResponse,
            );
          }
        } else if (e.response?.statusCode == 500) {
          Response<dynamic> responseData = Response(
            requestOptions: RequestOptions(path: ""),
            data: {
              "hasError": true,
              "message": e.response?.statusMessage,
              "statusCode": e.response?.statusCode,
              "data": e.response?.data,
            },
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage,
          );

          errorModel = APIResponse<dynamic>.fromJson(
            responseData,
            create: apiResponse,
          );
        } else {
          errorModel = APIResponse<dynamic>.fromJson(
            e.response!,
            create: apiResponse,
          );
        }

        return errorModel;
      }
      return APIResponse<dynamic>.custom(message: ErrorHandler.instance.getDioError(e));
    } catch (e) {
      if (request.mixPanelEventModel != null) {
        MixPanelService.instance.trackEvent(
          eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
          data: request.mixPanelEventModel?.errorData,
        );
      }
      if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
        MixPanelService.instance.trackEvent(
          eventName: _removeQueryParams(request.url),
        );
      }
      return APIResponse<dynamic>.custom(
        message: APIConstError.kSomethingWentWrong,
      );
    }
  }

  String setErrorData(List<ErrorDetails>? details) {
    String result = '';

    if (details != null) {
      Set<String> uniqueMsgs = Set<String>();

      for (var detail in details) {
        if (detail.msg != null && !uniqueMsgs.contains(detail.msg)) {
          uniqueMsgs.add(detail.msg ?? '');
          String appendedData = '${detail.msg}, ';
          result += appendedData;
        }
      }
    }

    result = result.trim().replaceAll(RegExp(r',\s*$'), '');

    return result;
  }

  String _removeQueryParams(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.path.replaceFirst('/', '').replaceAll('/', '-');
    } catch (e) {
      return url;
    }
  }

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
      final Response<dynamic>? response = await _getResponse(request: request, formData: formData);

      if (response != null) {
        if (request.mixPanelEventModel != null) {
          MixPanelService.instance.trackEvent(
            eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
            data: request.mixPanelEventModel?.successData,
          );
        }
        if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
          MixPanelService.instance.trackEvent(
            eventName: _removeQueryParams(request.url),
            data: response.data,
          );
        }

        if (response.data is Map<String, dynamic> && jsonMapper != null) {
          final data = await compute(jsonMapper, response.data as Map<String, dynamic>);
          return right(data);
        } else if (response.data is List<dynamic> && listJsonMapper != null) {
          final data = await compute(listJsonMapper, response.data as List<dynamic>);

          return right(data);
        }
        return right(response.data);
      }

      return left(ApiException(message: APIConstError.kSomethingWentWrong, response: response));
    } on DioException catch (e) {
      if (request.mixPanelEventModel != null) {
        MixPanelService.instance.trackEvent(
          eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
          data: request.mixPanelEventModel?.errorData,
        );
      }
      if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
        MixPanelService.instance.trackEvent(
          eventName: _removeQueryParams(request.url),
          data: e.response?.data,
        );
      }

      if (e.response != null) {
        final APIResponse<T> errorModel;

        if (e.response?.statusCode == 422) {
          if (e.response?.data['detail']?.isNotEmpty ?? false) {
            ApiErrorModel errorResponse = ApiErrorModel.fromJson(e.response?.data);
            String errorMessage = setErrorData(errorResponse.detail);

            debugPrint(errorMessage);

            Response<dynamic> responseData = Response(
              requestOptions: RequestOptions(path: ""),
              data: {
                "hasError": true,
                "message": errorMessage,
                "statusCode": e.response?.statusCode,
                "data": e.response?.data,
              },
              statusCode: e.response?.statusCode,
              statusMessage: errorMessage,
            );

            errorModel = APIResponse<T>.fromJson(responseData);
          } else {
            errorModel = APIResponse<T>.fromJson(e.response!);
          }
        } else if (e.response?.statusCode == 500) {
          Response<dynamic> responseData = Response(
            requestOptions: RequestOptions(path: ""),
            data: {
              "hasError": true,
              "message": e.response?.statusMessage,
              "statusCode": e.response?.statusCode,
              "data": e.response?.data,
            },
            statusCode: e.response?.statusCode,
            statusMessage: e.response?.statusMessage,
          );

          errorModel = APIResponse<T>.fromJson(responseData);
        } else {
          errorModel = APIResponse<T>.fromJson(e.response!);
        }

        return left(
          ApiException(
            message: errorModel.message ?? '',
            exception: e,
            statusCode: e.response?.statusCode,
            stackTrace: e.stackTrace,
            response: e.response,
          ),
        );
      }
      return left(
        ApiException(
          message: ErrorHandler.instance.getDioError(e),
          exception: e,
          statusCode: e.response?.statusCode,
          stackTrace: e.stackTrace,
          response: e.response,
        ),
      );
    } catch (e, stackTrace) {
      if (request.mixPanelEventModel != null) {
        MixPanelService.instance.trackEvent(
          eventName: request.mixPanelEventModel?.eventName ?? _removeQueryParams(request.url),
          data: request.mixPanelEventModel?.errorData,
        );
      }
      if (request.mixPanelEventModel == null && request.enableMixpanelTracking == true) {
        MixPanelService.instance.trackEvent(eventName: _removeQueryParams(request.url));
      }
      return left(
        ApiException(
          message: APIConstError.kSomethingWentWrong,
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

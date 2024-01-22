// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:master_utility/src/api_helper/api_error_model.dart';

// Project imports:
import 'package:master_utility/src/api_helper/dio_client.dart';

part 'api_error.dart';
part 'api_helper.dart';
part 'api_request.dart';
part 'api_response.dart';

class APIService {
  Future<Response<dynamic>> _getResponse({
    required APIRequest request,
    FormData? formData,
  }) async {
    Dio dio = dioClient.getDioClient(isAuth: request.isAuthorization);
    switch (request.methodType) {
      case MethodType.GET:
        return dio.get(
          request.url,
          options: Options(
            headers: request.header,
          ),
          queryParameters: request.queryParams,
        );

      case MethodType.POST:
        return dio.post(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.paramList ?? request.params,
          queryParameters: request.queryParams,
        );

      case MethodType.PATCH:
        return dio.patch(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params,
          queryParameters: request.queryParams,
        );

      case MethodType.PUT:
        return dio.put(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params,
          queryParameters: request.queryParams,
        );

      case MethodType.DELETE:
        return dio.delete(
          request.url,
          options: Options(headers: request.header),
          data: formData ?? request.params ?? request.paramList,
          queryParameters: request.queryParams,
        );
    }
  }

  Future<APIResponse<dynamic>> getApiResponse(
    APIRequest request, {
    Function(dynamic)? apiResponse,
  }) async {
    try {
      final Response<dynamic>? response = await _getResponse(
        request: request,
      );

      if (response != null) {
        return APIResponse<dynamic>.fromJson(
          response,
          create: apiResponse,
        );
      }
      return APIResponse<dynamic>.custom(
        message: APIConstError.kSomethingWentWrong,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final APIResponse<dynamic> errorModel;
        if (e.response?.statusCode == 422) {
          if (e.response?.data['detail']?.isNotEmpty ?? false) {
            ApiErrorModel errorResponse = ApiErrorModel.fromJson(e.response?.data);
            String errorMessage = setErrordData(errorResponse.detail);

            debugPrint(errorMessage);

            Response<dynamic> resposneData = Response(
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
              resposneData,
              create: apiResponse,
            );
          } else {
            errorModel = APIResponse<dynamic>.fromJson(
              e.response!,
              create: apiResponse,
            );
          }
        } else if (e.response?.statusCode == 500) {
          Response<dynamic> resposneData = Response(
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
            resposneData,
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
      return APIResponse<dynamic>.custom(
        message: ErrorHandler.instance.getDioError(e),
      );
    } catch (e) {
      return APIResponse<dynamic>.custom(
        message: APIConstError.kSomethingWentWrong,
      );
    }
  }

  String setErrordData(List<ErrorDetails>? details) {
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
}

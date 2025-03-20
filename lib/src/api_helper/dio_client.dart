// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
// Project imports:
import 'package:master_utility/src/api_helper/interceptor/authorization.dart';
import 'package:master_utility/src/api_helper/interceptor/curl_logger.dart';

DioClient dioClient = DioClient();

class DioClient {
  Dio? _dio;

  void Function(DioException, ErrorInterceptorHandler)? globalOnErrorHandler;
  Dio getDioClient({
    bool isAuth = true,
    void Function(
      DioException dioException,
      ErrorInterceptorHandler errorInterceptorHandler,
    )? callback,
  }) {
    _dio?.interceptors.clear();

    final interceptors = <Interceptor>[];

    if (isAuth) {
      interceptors.add(AuthTokenInterceptor());
    }

    if (_isApiLogVisible) {
      interceptors.add(HttpFormatter(loggingFilter: (request, response, error) => true));
      interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }

    interceptors.addAll([
      InterceptorsWrapper(onError: callback),
      if (globalOnErrorHandler != null) ...[InterceptorsWrapper(onError: globalOnErrorHandler)],
    ]);

    _dio?.interceptors.addAll(interceptors);

    return _dio!;
  }

  DioClient setConfiguration(String baseUrl,
      {Map<String, dynamic>? headers, void Function(DioException, ErrorInterceptorHandler)? globalOnErrorHandler}) {
    if (globalOnErrorHandler != null) {
      this.globalOnErrorHandler = globalOnErrorHandler;
    }
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(
        milliseconds: 30000,
      ),
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      contentType: ContentType.json.toString(),
      headers: headers,
    );

    _dio = Dio(options);

    if (kIsWeb) {
      (_dio?.httpClientAdapter as dynamic).withCredentials = true;
    }

    return this;
  }

  static bool _isApiLogVisible = true;
  static void setIsApiLogVisible({required bool isVisible}) {
    if (kReleaseMode) {
      _isApiLogVisible = false;
    } else {
      _isApiLogVisible = isVisible;
    }
  }
}

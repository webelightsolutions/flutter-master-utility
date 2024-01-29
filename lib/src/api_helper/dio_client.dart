// Dart imports:

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';

// Project imports:
import 'package:master_utility/src/api_helper/interceptor/authorization.dart';

// Flutter imports:

DioClient dioClient = DioClient();

class DioClient {
  Dio? _dio;

  Dio getDioClient({bool isAuth = true}) {
    _dio?.interceptors.clear();

    final interceptors = <Interceptor>[];

    if (isAuth) {
      interceptors.add(AuthTokenInterceptor());
    }

    if (_isApiLogVisible) {
      interceptors.add(HttpFormatter());
    }

    _dio?.interceptors.addAll(interceptors);

    return _dio!;
  }

  DioClient setConfiguration(
    String baseUrl, {
    Map<String, dynamic>? headers,
  }) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(
          milliseconds: 30000,
        ),
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        contentType: ContentType.json.toString(),
        headers: headers,
      ),
    );

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

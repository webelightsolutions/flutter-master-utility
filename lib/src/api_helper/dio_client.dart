// Dart imports:
import 'dart:io';

import 'package:dio_http_formatter/dio_http_formatter.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:master_utility/master_utility.dart';
// Project imports:
import 'package:master_utility/src/api_helper/interceptor/authorization.dart';
import 'package:master_utility/src/api_helper/interceptor/curl_logger.dart';

DioClient dioClient = DioClient();

class DioClient {
  Dio? _dio;
  RefreshTokenConfiguration? _refreshTokenConfiguration;
  Logarte? _logarteClient;

  Dio getDioClient({
    bool isAuth = true,
    void Function(
      DioException dioException,
      ErrorInterceptorHandler errorInterceptorHandler,
    )? callback,
  }) {
    _dio?.interceptors.clear();

    final interceptors = <Interceptor>[];

    /// This will load access token from [PreferenceHelper]
    if (_refreshTokenConfiguration == null && isAuth) {
      interceptors.add(AuthTokenInterceptor());
    }

    if (_isApiLogVisible) {
      interceptors.add(HttpFormatter(loggingFilter: (request, response, error) => true));
      interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }

    if (_logarteClient != null) {
      _dio?.interceptors.add(LogarteDioInterceptor(_logarteClient!));
    }

    interceptors.add(
      InterceptorsWrapper(onError: callback),
    );

    if (_refreshTokenConfiguration != null && isAuth) {
      _addJWTInterceptor(_refreshTokenConfiguration!);
    }

    _dio?.interceptors.addAll(interceptors);

    return _dio!;
  }

  DioClient setRefreshTokenConfiguration({
    required RefreshTokenConfiguration refreshTokenConfiguration,
  }) {
    _refreshTokenConfiguration = refreshTokenConfiguration;
    _addJWTInterceptor(refreshTokenConfiguration);
    return this;
  }

  void _addJWTInterceptor(RefreshTokenConfiguration config) {
    _dio?.interceptors.add(
      JwtHeroInterceptor(
        tokenStorage: config.tokenStorage,
        baseClient: _dio ?? Dio(),
        onRefresh: (refreshClient, refreshToken) async {
          refreshClient.options =
              refreshClient.options.copyWith(headers: {config.refreshTokenHeaderKey: 'Bearer $refreshToken'});
          final response = await refreshClient.post(config.refreshTokenEndPoint);
          final token = config.responseMapper(response.data);
          return token;
        },
        sessionManager: config.sessionManager,
      ),
    );
  }

  DioClient setConfiguration(
    String baseUrl, {
    Map<String, dynamic>? headers,
    Logarte? logarteClient,
  }) {
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

    _logarteClient = logarteClient;

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

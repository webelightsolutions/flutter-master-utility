// Dart imports:
import 'dart:io';

import 'package:dio_http_formatter/dio_http_formatter.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:master_utility/master_utility.dart';
// Project imports:
import 'package:master_utility/src/api_helper/interceptor/authorization.dart';
import 'package:master_utility/src/api_helper/interceptor/curl_logger.dart';
import 'package:master_utility/src/secure_token_storage_helper.dart';

DioClient dioClient = DioClient();

class DioClient {
  Dio? _dio;
  RefreshTokenConfiguration? _refreshTokenConfiguration;

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

    interceptors.add(
      InterceptorsWrapper(onError: callback),
    );

    if (_refreshTokenConfiguration != null) {
      _dio?.interceptors.add(
        JwtHeroInterceptor(
          tokenStorage: SecureTokenStorageHelper.getInstance(),
          baseClient: _dio ?? Dio(),
          onRefresh: (refreshClient, refreshToken) async {
            refreshClient.interceptors.add(HttpFormatter(loggingFilter: (request, response, error) => true));
            refreshClient.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
            refreshClient.options = refreshClient.options.copyWith(
              headers: {_refreshTokenConfiguration!.refreshTokenHeaderKey: 'Bearer $refreshToken'},
            );
            final response = await refreshClient.post(_refreshTokenConfiguration!.refreshTokenEndPoint);
            LogHelper.logInfo('Response : ${response.data}');
            final transformedData = _refreshTokenConfiguration!.mapResponse(response.data);
            final token = JwtToken(
              accessToken: transformedData[_refreshTokenConfiguration!.accessTokenResponseKey],
              refreshToken: transformedData[_refreshTokenConfiguration!.refreshTokenResponseKey],
            );

            await SecureTokenStorageHelper.getInstance().saveToken(token);
            return token;
          },
          sessionManager: _refreshTokenConfiguration!.sessionManager,
        ),
      );
    }

    _dio?.interceptors.addAll(interceptors);

    return _dio!;
  }

  DioClient setRefreshTokenConfiguration({
    required RefreshTokenConfiguration refreshTokenConfiguration,
  }) {
    _refreshTokenConfiguration = refreshTokenConfiguration;
    SecureTokenStorageHelper.initialize(
      accessTokenKey: refreshTokenConfiguration.accessTokenStorageKey,
      refreshTokenKey: refreshTokenConfiguration.refreshTokenStorageKey,
    );

    if (_isApiLogVisible) {
      _dio?.interceptors.add(HttpFormatter(loggingFilter: (request, response, error) => true));
      _dio?.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }

    _dio?.interceptors.add(
      JwtHeroInterceptor(
        tokenStorage: SecureTokenStorageHelper.getInstance(),
        baseClient: _dio ?? Dio(),
        onRefresh: (refreshClient, refreshToken) async {
          refreshClient.options = refreshClient.options.copyWith(
            headers: {refreshTokenConfiguration.refreshTokenHeaderKey: refreshToken},
          );
          final response = await refreshClient.post(refreshTokenConfiguration.refreshTokenEndPoint);
          final transformedData = refreshTokenConfiguration.mapResponse(response.data);
          final token = JwtToken(
            accessToken: transformedData[refreshTokenConfiguration.accessTokenResponseKey],
            refreshToken: transformedData[refreshTokenConfiguration.refreshTokenResponseKey],
          );

          await SecureTokenStorageHelper.getInstance().saveToken(token);
          return token;
        },
        sessionManager: refreshTokenConfiguration.sessionManager,
      ),
    );

    return this;
  }

  DioClient setConfiguration(
    String baseUrl, {
    Map<String, dynamic>? headers,
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

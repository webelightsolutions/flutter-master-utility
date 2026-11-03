import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:logarte/logarte.dart';
import 'package:master_utility/src/api_helper/interceptors/auth_token_interceptor.dart';
import 'package:master_utility/src/api_helper/interceptors/curl_logger_interceptor.dart';
import 'package:master_utility/src/api_helper/interceptors/jwt/jwt_interceptor_builder.dart';
import 'package:master_utility/src/api_helper/interceptors/jwt/refresh_token_configuration.dart';
import 'package:master_utility/src/api_helper/type_defs.dart';

/// The app-wide client. Configure it once with [DioClient.setConfiguration].
DioClient dioClient = DioClient();

/// Owns the single [Dio] instance used by `APIService`, and its interceptors.
class DioClient {
  Dio? _dio;
  Logarte? _logarteClient;
  RefreshTokenConfiguration? _refreshTokenConfiguration;

  /// Maps error responses to messages. When set, it replaces the built-in mapping.
  CustomErrorMapper<dynamic>? customErrorMapper;

  /// Called for every failed request (after the request's own `onError`, if that passes the error on).
  InterceptorErrorCallback? globalOnErrorHandler;

  static bool _isApiLogVisible = true;

  /// Turns HTTP and curl logs on or off for every request. Always off in release builds.
  static void setIsApiLogVisible({required bool isVisible}) {
    _isApiLogVisible = !kReleaseMode && isVisible;
  }

  /// Creates the client. Call this once, before any request.
  DioClient setConfiguration(
    String baseUrl, {
    Map<String, dynamic>? headers,
    Logarte? logarteClient,
    CustomErrorMapper? customErrorMapper,
    int connectTimeoutMs = 30000,
    InterceptorErrorCallback? globalOnErrorHandler,
  }) {
    this.customErrorMapper = customErrorMapper;
    this.globalOnErrorHandler = globalOnErrorHandler;
    _logarteClient = logarteClient;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
        connectTimeout: Duration(milliseconds: connectTimeoutMs),
        responseType: ResponseType.json,
        contentType: ContentType.json.toString(),
      ),
    );

    if (kIsWeb) {
      // Send cookies with cross-origin requests on web.
      (_dio?.httpClientAdapter as dynamic).withCredentials = true;
    }

    return this;
  }

  /// Switches authorization from the stored access token to JWT with automatic refresh.
  DioClient setRefreshTokenConfiguration({
    required RefreshTokenConfiguration refreshTokenConfiguration,
  }) {
    _refreshTokenConfiguration = refreshTokenConfiguration;

    final Dio? dio = _dio;
    if (dio != null) {
      dio.interceptors.add(buildJwtInterceptor(configuration: refreshTokenConfiguration, baseClient: dio));
    }
    return this;
  }

  /// The configured client. Call [setConfiguration] first.
  Dio get dio => _dio!;

  /// Returns [dio] with its interceptors rebuilt for one request's options.
  Dio getDioClient({
    bool isAuth = true,
    bool showHttpLogging = true,
    bool showCurlLogging = true,
    InterceptorErrorCallback? callback,
  }) {
    final Dio dio = _dio!;

    // Order matters: logarte → auth → http log → curl log → request onError → global onError.
    dio.interceptors
      ..clear()
      ..addAll([
        if (_logarteClient != null) LogarteDioInterceptor(_logarteClient!),
        if (isAuth) _authInterceptor(dio),
        if (_isApiLogVisible && showHttpLogging) HttpFormatter(loggingFilter: (request, response, error) => true),
        if (_isApiLogVisible && showCurlLogging) CurlLoggerDioInterceptor(printOnSuccess: true),
        InterceptorsWrapper(onError: callback),
        if (globalOnErrorHandler != null) InterceptorsWrapper(onError: globalOnErrorHandler),
      ]);

    return dio;
  }

  /// JWT refresh when configured, otherwise the access token saved in `PreferenceHelper`.
  Interceptor _authInterceptor(Dio dio) {
    final RefreshTokenConfiguration? refreshTokenConfiguration = _refreshTokenConfiguration;
    if (refreshTokenConfiguration == null) return AuthTokenInterceptor();
    return buildJwtInterceptor(configuration: refreshTokenConfiguration, baseClient: dio);
  }
}

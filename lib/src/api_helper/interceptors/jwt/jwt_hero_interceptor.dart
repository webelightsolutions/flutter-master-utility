import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:master_utility/src/api_helper/interceptors/curl_logger_interceptor.dart';

import 'jwt_refresher_mixin.dart';
import 'refresh_typedef.dart';
import 'request_retry_mixin.dart';
import 'revoke_token_exception.dart';
import 'session_manager.dart';
import 'token_storage.dart';
import 'token_validator_ext.dart';

/// Adds the JWT to requests, refreshes it when expired or rejected (401), and retries the request.
class JwtHeroInterceptor extends QueuedInterceptor with JwtRefresherMixin, RequestRetryMixin<Response<dynamic>> {
  JwtHeroInterceptor({
    required this.tokenStorage,
    required this.baseClient,
    required this.onRefresh,
    required this.sessionManager,
  }) {
    refreshClient = Dio();
    refreshClient.options = BaseOptions(baseUrl: baseClient.options.baseUrl);

    retryClient = Dio();
    retryClient.options = BaseOptions(baseUrl: baseClient.options.baseUrl);

    _attachHttpLoggers(refreshClient);
    _attachHttpLoggers(retryClient);
  }

  void _attachHttpLoggers(Dio client) {
    client.interceptors.addAll([
      HttpFormatter(loggingFilter: (request, response, error) => true),
      CurlLoggerDioInterceptor(printOnSuccess: true),
    ]);
  }

  /// The storage to load and save the JWT token.
  final TokenStorage tokenStorage;

  /// The base client to make requests.
  final Dio baseClient;

  /// The client to make requests to refresh the JWT token.
  late final Dio refreshClient;

  /// The client to retry the request after refreshing the JWT token.
  late final Dio retryClient;

  /// The function to refresh the JWT token.
  final Refresh onRefresh;

  /// The session manager to expire the session.
  final SessionManager sessionManager;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final jwtToken = await tokenStorage.loadToken();

      // No token yet (e.g. before login): send the request as is.
      if (jwtToken == null) {
        return handler.next(options);
      }

      // Expired token: refresh first, then send with the new one.
      if (!jwtToken.isValid) {
        await refresh(
          options: options,
          currentJwtToken: jwtToken,
          refreshClient: refreshClient,
          tokenStorage: tokenStorage,
          onRefresh: onRefresh,
        );
      }

      options.headers.addAll(await _buildHeaders());
      return handler.next(options);
    } on DioException {
      // Refresh failed: send the request anyway; a 401 is handled in onError.
      return handler.next(options);
    } on Exception {
      // Any other failure: send the request anyway; onError handles the outcome.
      return handler.next(options);
    }
  }

  @override
  Future<void> onError(DioException dioException, ErrorInterceptorHandler handler) async {
    if (dioException is RevokeTokenException) {
      sessionManager.expireSession();
      return handler.reject(dioException);
    }

    if (!shouldRefresh(dioException.response)) {
      return handler.next(dioException);
    }

    final jwtToken = await tokenStorage.loadToken();
    if (jwtToken == null) {
      return handler.reject(dioException);
    }

    // The server rejected the token (401): refresh it and retry the request once.
    try {
      await refresh(
        options: dioException.requestOptions,
        currentJwtToken: jwtToken,
        refreshClient: refreshClient,
        tokenStorage: tokenStorage,
        onRefresh: onRefresh,
      );

      final retriedResponse = await retry(
        retryClient: retryClient,
        requestOptions: dioException.requestOptions,
        buildHeaders: _buildHeaders,
      );

      return handler.resolve(retriedResponse);
    } on RevokeTokenException {
      sessionManager.expireSession();
      return handler.reject(dioException);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  /// Builds the headers with the JWT token.
  Future<Map<String, String>> _buildHeaders() async {
    final jwtToken = await tokenStorage.loadToken();

    return {HttpHeaders.authorizationHeader: 'Bearer ${jwtToken!.accessToken}'};
  }

  /// Checks if the response should be refreshed.
  bool shouldRefresh<R>(Response<R>? response) => response?.statusCode == 401;
}

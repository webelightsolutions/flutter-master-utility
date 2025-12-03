import 'dart:io';

import 'package:dio/dio.dart';

import 'jwt_refresher_mixin.dart';
import 'refresh_typedef.dart';
import 'request_retry_mixin.dart';
import 'revoke_token_exception.dart';
import 'session_manager.dart';
import 'token_storage.dart';
import 'token_validator_ext.dart';

/// {@template jwt_hero_interceptor}
/// Intercepts HTTP requests to handle JWT token management.
///
/// This interceptor is responsible for adding JWT tokens to request headers,
/// refreshing expired tokens, and retrying requests with new tokens if needed.
/// It uses the provided token storage to load and validate tokens, and the
/// session manager to handle session expiration.
///
/// The interceptor also initializes separate clients for refreshing tokens
/// and retrying requests.
///
/// Mixins:
/// - [JwtRefresherMixin]: Provides functionality to refresh JWT tokens.
/// - [RequestRetryMixin]: Provides functionality to retry requests.
/// {@endtemplate}
class JwtHeroInterceptor extends QueuedInterceptor
    with JwtRefresherMixin, RequestRetryMixin<Response<dynamic>> {
  /// {@macro jwt_hero_interceptor}
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
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      /// Load the JWT token from the storage.
      final jwtToken = await tokenStorage.loadToken();

      /// If the JWT token is null, continue with the request.
      if (jwtToken == null) {
        return handler.next(options);
      }

      /// If the JWT token is valid, add it to the request headers and continue
      /// with the request.
      /// If the JWT token is not valid, refresh it and add it to the request
      /// headers.
      if (jwtToken.isValid) {
        options.headers.addAll(await _buildHeaders());
        return handler.next(options);
      } else {
        await refresh(
          options: options,
          currentJwtToken: jwtToken,
          refreshClient: refreshClient,
          tokenStorage: tokenStorage,
          onRefresh: onRefresh,
        );

        options.headers.addAll(await _buildHeaders());
        return handler.next(options);
      }
    } on DioException catch (_) {
      /// If the response status code is 401, reject the request.
      /// This is to prevent an infinite loop of refreshing the token.
      /// The request will be retried in the onError method.

      return handler.next(options);
    } on Exception {
      /// If an error occurs, continue with the request.
      /// This is to prevent the request from being rejected.
      /// The error will be handled in the onError method.
      return handler.next(options);
    }
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    /// If the error is a RevokeTokenException, expire the session and reject
    /// the request.
    if (err is RevokeTokenException) {
      sessionManager.expireSession();
      return handler.reject(err);
    }

    /// If the response status code is not 401, continue with the error.
    if (!shouldRefresh(err.response)) {
      return handler.next(err);
    }

    /// Load the JWT token from the storage.
    final jwtToken = await tokenStorage.loadToken();

    /// If the JWT token is null, reject the request.
    if (jwtToken == null) {
      return handler.reject(err);
    }

    /// If the JWT token is valid, retry the request.
    /// If the JWT token is not valid, refresh it and retry the request.
    try {
      if (jwtToken.isValid && shouldRefresh(err.response)) {
        final previousRequest = await retry(
          retryClient: retryClient,
          requestOptions: err.requestOptions,
          buildHeaders: _buildHeaders,
        );

        return handler.resolve(previousRequest);
      } else {
        await refresh(
          options: err.requestOptions,
          currentJwtToken: jwtToken,
          refreshClient: refreshClient,
          tokenStorage: tokenStorage,
          onRefresh: onRefresh,
        );

        /// Retry the request.
        final previousRequest = await retry(
          retryClient: retryClient,
          requestOptions: err.requestOptions,
          buildHeaders: _buildHeaders,
        );

        return handler.resolve(previousRequest);
      }
    } on RevokeTokenException {
      sessionManager.expireSession();
      return handler.reject(err);
    } on DioException catch (err) {
      return handler.next(err);
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

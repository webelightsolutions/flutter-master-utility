import 'package:dio/dio.dart';

import 'jwt_hero_interceptor.dart';
import 'jwt_token.dart';
import 'refresh_token_configuration.dart';

/// Creates the [JwtHeroInterceptor] for a [RefreshTokenConfiguration].
JwtHeroInterceptor buildJwtInterceptor({
  required RefreshTokenConfiguration configuration,
  required Dio baseClient,
}) {
  return JwtHeroInterceptor(
    tokenStorage: configuration.tokenStorage,
    sessionManager: configuration.sessionManager,
    baseClient: baseClient,
    onRefresh: (refreshClient, refreshToken) => _requestNewToken(configuration, refreshClient, refreshToken),
  );
}

/// Calls the app's refresh endpoint and maps the response to a new [JwtToken].
Future<JwtToken> _requestNewToken(
  RefreshTokenConfiguration configuration,
  Dio refreshClient,
  String refreshToken,
) async {
  final Map<String, dynamic> refreshHeaders = await configuration.headers?.call() ??
      {configuration.refreshTokenHeaderKey: 'Bearer $refreshToken'};
  final Object? refreshBody = await configuration.bodyData?.call();

  refreshClient.options = refreshClient.options.copyWith(headers: refreshHeaders);
  final Response<dynamic> refreshResponse = await refreshClient.post(
    configuration.refreshTokenEndPoint,
    data: refreshBody,
  );
  return configuration.responseMapper(refreshResponse.data);
}

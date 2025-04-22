import 'package:jwt_hero/jwt_hero.dart';

typedef ResponseMapper = Map<String, dynamic> Function(dynamic responseData);

class RefreshTokenConfiguration {
  final String refreshTokenEndPoint;
  final String refreshTokenHeaderKey;
  final String accessTokenStorageKey;
  final String refreshTokenStorageKey;
  final String accessTokenResponseKey;
  final String refreshTokenResponseKey;
  final SecureTokenStorage? tokenStorage;
  final SessionManager sessionManager;
  final ResponseMapper responseMapper;

  RefreshTokenConfiguration({
    required this.refreshTokenEndPoint,
    required this.sessionManager,
    required this.responseMapper,
    this.tokenStorage,
    this.refreshTokenHeaderKey = 'refresh-Token',
    this.accessTokenStorageKey = 'authorization',
    this.refreshTokenStorageKey = 'refreshToken',
    this.accessTokenResponseKey = 'access_token',
    this.refreshTokenResponseKey = 'refresh_token',
  });

  /// Transform the response data using the custom transformer if provided
  Map<String, dynamic> mapResponse(dynamic responseData) {
    return responseMapper(responseData);
  }
}

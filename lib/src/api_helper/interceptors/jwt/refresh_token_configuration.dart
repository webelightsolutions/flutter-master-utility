import 'dart:io';

import 'package:master_utility/src/api_helper/interceptors/jwt/jwt_token.dart';
import 'package:master_utility/src/api_helper/interceptors/jwt/session_manager.dart';
import 'package:master_utility/src/api_helper/interceptors/jwt/token_storage.dart';

typedef ResponseMapper = JwtToken Function(dynamic responseData);

typedef BodyDataCallback = Future<Object>? Function();
typedef HeadersCallback = Future<Map<String, dynamic>>? Function();

/// How to refresh an expired access token. Pass it to `dioClient.setRefreshTokenConfiguration`.
class RefreshTokenConfiguration {
  final String refreshTokenEndPoint;
  final String refreshTokenHeaderKey;
  final TokenStorage tokenStorage;
  final SessionManager sessionManager;
  final ResponseMapper responseMapper;
  final BodyDataCallback? bodyData;
  final HeadersCallback? headers;

  RefreshTokenConfiguration({
    required this.refreshTokenEndPoint,
    required this.sessionManager,
    required this.responseMapper,
    required this.tokenStorage,
    this.refreshTokenHeaderKey = HttpHeaders.authorizationHeader,
    this.bodyData,
    this.headers,
  });
}

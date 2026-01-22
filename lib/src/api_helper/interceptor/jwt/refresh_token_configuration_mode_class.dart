import 'dart:io';

import 'package:master_utility/master_utility.dart';

typedef ResponseMapper = JwtToken Function(dynamic responseData);

// Define typedefs for the callbacks
typedef BodyDataCallback = Object? Function();
typedef HeadersCallback = Map<String, dynamic> Function();

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

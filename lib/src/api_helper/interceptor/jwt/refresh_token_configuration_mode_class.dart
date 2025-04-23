import 'dart:io';

import 'package:master_utility/master_utility.dart';

typedef ResponseMapper = JwtToken Function(dynamic responseData);

class RefreshTokenConfiguration {
  final String refreshTokenEndPoint;
  final String refreshTokenHeaderKey;
  final TokenStorage tokenStorage;
  final SessionManager sessionManager;
  final ResponseMapper responseMapper;

  RefreshTokenConfiguration({
    required this.refreshTokenEndPoint,
    required this.sessionManager,
    required this.responseMapper,
    required this.tokenStorage,
    this.refreshTokenHeaderKey = HttpHeaders.authorizationHeader,
  });
}

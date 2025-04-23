import 'package:dio/dio.dart';

import 'jwt_token.dart';

/// The function to refresh the JWT token.
typedef Refresh = Future<JwtToken> Function(Dio refreshClient, String refreshToken);

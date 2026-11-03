import 'package:dio/dio.dart';

import 'jwt_token.dart';
import 'refresh_typedef.dart';
import 'revoke_token_exception.dart';
import 'token_storage.dart';

/// A mixin responsible for refreshing JWT tokens.
mixin JwtRefresherMixin {
  /// Refreshes the JWT token using the provided [onRefresh] function.
  Future<JwtToken> refresh({
    required RequestOptions options,
    JwtToken? currentJwtToken,
    required Dio refreshClient,
    required TokenStorage tokenStorage,
    required Refresh onRefresh,
  }) async {
    if (currentJwtToken == null) {
      throw RevokeTokenException(requestOptions: options);
    }

    try {
      final JwtToken newJwtToken = await onRefresh(
        refreshClient,
        currentJwtToken.refreshToken,
      );

      await tokenStorage.saveToken(newJwtToken);
      return newJwtToken;
    } on DioException catch (refreshError) {
      if (refreshError.response != null && refreshError.response!.statusCode == 401) {
        throw RevokeTokenException(requestOptions: options);
      } else {
        rethrow;
      }
    }
  }
}

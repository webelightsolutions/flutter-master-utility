import 'jwt_token.dart';

/// {@template token_storage}
/// The interface for token storage.
///
/// This interface is used by the JwtHeroInterceptor
/// to store and retrieve the Auth token pair.
/// {@endtemplate}
abstract interface class TokenStorage {
  /// Load the Auth token pair.
  Future<JwtToken?> loadToken();

  /// Save the Auth token pair.
  Future<void> saveToken(JwtToken token);

  /// Clear the Auth token pair.
  ///
  /// This is used to clear the token pair when the request fails with a 401.
  Future<void> clear();

  /// access token from token storage
  Future<String?> get accessToken;

  /// refresh token from token storage
  Future<String?> get refreshToken;
}

import 'jwt_token.dart';

/// The interface for token storage.
abstract class TokenStorage {
  /// Load the Auth token pair.
  Future<JwtToken?> loadToken();

  /// Save the Auth token pair.
  Future<void> saveToken(JwtToken token);

  /// Clear the Auth token pair.
  Future<void> clear();

  /// access token from token storage
  Future<String?> get accessToken;

  /// refresh token from token storage
  Future<String?> get refreshToken;
}

/// {@template jwt_token}
/// A class that represents a JWT token.
/// {@endtemplate}
final class JwtToken {
  /// {@macro jwt_token}
  JwtToken({required this.accessToken, required this.refreshToken});

  /// The access token.
  final String accessToken;

  /// The refresh token.
  final String refreshToken;
}

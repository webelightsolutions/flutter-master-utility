/// A class that represents a JWT token.
class JwtToken {
  JwtToken({required this.accessToken, required this.refreshToken});

  /// The access token.
  final String accessToken;

  /// The refresh token.
  final String refreshToken;
}

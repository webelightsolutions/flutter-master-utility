import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'jwt_token.dart';

/// Extension methods for the [JwtToken] class.
extension TokenValidatorExt on JwtToken {
  /// Returns `true` if the access token is valid.
  bool get isValid {
    /// Decode the access token.
    final decodedJwt = JWT.decode(accessToken);

    /// Get the expiration time from the decoded JWT.
    final expirationTimeEpoch =
        (decodedJwt.payload as Map<String, dynamic>)['exp'];

    /// Convert the expiration time to a [DateTime] object.
    final expirationDateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse('$expirationTimeEpoch') * 1000,
    );

    /// Check if the current time is before the expiration time.
    return DateTime.now().isBefore(expirationDateTime);
  }
}

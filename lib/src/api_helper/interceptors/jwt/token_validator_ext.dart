import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'jwt_token.dart';

/// Extension methods for the [JwtToken] class.
extension TokenValidatorExt on JwtToken {
  /// Returns `true` if the access token is valid.
  bool get isValid {
    try {
      if (accessToken.isEmpty) {
        return false;
      }

      final decodedJwt = JWT.decode(accessToken);

      final expirationTimeEpoch =
          (decodedJwt.payload as Map<String, dynamic>)['exp'];

      final expirationDateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse('$expirationTimeEpoch') * 1000,
      );

      return DateTime.now().isBefore(expirationDateTime);
    } catch (decodeError) {
      return false;
    }
  }
}

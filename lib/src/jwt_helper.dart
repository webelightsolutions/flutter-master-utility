// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:master_utility/src/jwt_decoder/jwt_decoder.dart';
import '../master_utility.dart';

class JWTHelper {
  /// handle JWT Expire
  static Future<bool> handleJWT(
      {required VoidCallback onSuccess, required String token}) async {
    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (isTokenExpired) onSuccess();

    /// this method returns the expiration date of the token
    final expirationDate = JwtDecoder.getExpirationDate(token);
    LogHelper.logInfo(expirationDate);

    return isTokenExpired;
  }
}

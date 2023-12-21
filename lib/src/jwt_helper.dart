// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:jwt_decoder/jwt_decoder.dart';

// Project imports:
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

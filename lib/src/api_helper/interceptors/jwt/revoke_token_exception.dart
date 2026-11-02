import 'package:dio/dio.dart';

/// Exception thrown when the token is revoked.
class RevokeTokenException extends DioException {
  RevokeTokenException({required super.requestOptions});
}

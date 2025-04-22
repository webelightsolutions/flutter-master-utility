import 'package:dio/dio.dart';

/// {template dio_exception}
/// Exception thrown when the token is revoked.
/// {endtemplate}
class RevokeTokenException extends DioException {
  /// {template dio_exception}
  RevokeTokenException({required super.requestOptions});
}

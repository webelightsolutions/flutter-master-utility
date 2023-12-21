// ignore_for_file: constant_identifier_names

part of 'api_service.dart';

enum MethodType {
  GET,
  POST,
  PATCH,
  PUT,
  DELETE,
}

class APIException implements Exception {
  APIException(this._message);

  final String _message;

  @override
  String toString() {
    return _message;
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:master_utility/master_utility.dart';

class CurlLoggerDioInterceptor extends Interceptor {
  final bool? printOnSuccess;
  final bool convertFormData;

  CurlLoggerDioInterceptor({this.printOnSuccess, this.convertFormData = true});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _renderCurlRepresentation(err.requestOptions, isError: true);

    return handler.next(err); //continue
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (printOnSuccess != null && printOnSuccess == true) {
      _renderCurlRepresentation(response.requestOptions);
    }

    return handler.next(response); //continue
  }

  void _renderCurlRepresentation(RequestOptions requestOptions, {bool isError = false}) {
    try {
      final curlCommand = _generateCurlCommand(requestOptions);
      log(curlCommand);
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }

  String _generateCurlCommand(RequestOptions options) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();
    final headers = options.headers;
    final data = options.data;

    final buffer = StringBuffer();

    buffer.write("curl -X '$method' \\\n");
    buffer.write("  '$url' \\\n");

    if (headers.isNotEmpty) {
      headers.forEach((key, value) {
        buffer.write("  -H '$key: $value' \\\n");
      });
    }

    if (data != null) {
      if (data is Map) {
        final jsonData = jsonEncode(data);
        buffer.write("  -d '${jsonData.replaceAll("'", r"'\''")}' \\\n");
      } else {
        buffer.write("  -d '${data.toString().replaceAll("'", r"'\''")}' \\\n");
      }
    }

    return buffer.toString().trimRight();
  }
}

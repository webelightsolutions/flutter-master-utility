import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

/// Logs every request as a copy-pasteable `curl` command.
class CurlLoggerDioInterceptor extends Interceptor {
  final bool? printOnSuccess;

  CurlLoggerDioInterceptor({this.printOnSuccess});

  @override
  void onError(DioException dioException, ErrorInterceptorHandler handler) {
    _renderCurlRepresentation(dioException.requestOptions);

    return handler.next(dioException);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (printOnSuccess != null && printOnSuccess == true) {
      _renderCurlRepresentation(response.requestOptions);
    }

    return handler.next(response);
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    try {
      log(_generateCurlCommand(requestOptions));
    } catch (curlBuildError) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }

  String _generateCurlCommand(RequestOptions requestOptions) {
    final String method = requestOptions.method.toUpperCase();
    final String url = requestOptions.uri.toString();
    final Map<String, dynamic> headers = requestOptions.headers;
    final dynamic requestBody = requestOptions.data;

    final StringBuffer curlCommand = StringBuffer();

    curlCommand.write("curl -X '$method' \\\n");
    curlCommand.write("  '$url' \\\n");

    headers.forEach((headerName, headerValue) {
      curlCommand.write("  -H '$headerName: $headerValue' \\\n");
    });

    if (requestBody != null) {
      final String bodyText = requestBody is Map ? jsonEncode(requestBody) : requestBody.toString();
      curlCommand.write("  -d '${bodyText.replaceAll("'", r"'\''")}' \\\n");
    }

    return curlCommand.toString().trimRight();
  }
}

import 'package:dio/dio.dart';

/// {@template request_retry_mixin}
/// A mixin in charge of retrying the request with the new JWT token.
///
/// This mixin provides the functionality to retry HTTP requests with a new
/// JWT token after the original token has expired and been refreshed. It
/// defines a method to handle the retry process, which includes updating
/// the request headers with the new token and resending the request.
///
/// The mixin is intended to be used with classes that manage HTTP requests
/// and need to handle automatic retries with refreshed JWT tokens.
/// {@endtemplate}
mixin RequestRetryMixin<R> {
  /// Retries the request with the new JWT token.
  Future<Response<R>> retry({
    required Dio retryClient,
    required RequestOptions requestOptions,
    required Future<Map<String, String>> Function() buildHeaders,
  }) async {
    return retryClient.request<R>(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data:
          requestOptions.data is FormData
              ? (requestOptions.data as FormData).clone()
              : requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers..addAll(await buildHeaders()),
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
        listFormat: requestOptions.listFormat,
      ),
    );
  }
}

part of 'api_service.dart';

class APIRequest {
  APIRequest({
    this.file,
    this.isAuthorization = true,
    required this.url,
    required this.methodType,
    this.params,
    this.queryParams,
    this.header,
    this.paramList,
    this.onError,
    this.cancelToken,
    this.onReceiveProgress,
    this.onSendProgress,
    this.showHttpLogging = true,
    this.showCurlLogging = true,
  });

  File? file;
  String url;

  /// use `HttpHeaders.authorizationHeader` to store Auth key
  bool isAuthorization;
  MethodType methodType;
  Map<String, dynamic>? params;
  List<dynamic>? paramList;
  Map<String, dynamic>? queryParams;
  Map<String, dynamic>? header;
  CancelToken? cancelToken;
  void Function(int, int)? onReceiveProgress;
  void Function(int, int)? onSendProgress;
  bool showHttpLogging;
  bool showCurlLogging;

  void Function(
    DioException dioException,
    ErrorInterceptorHandler errorInterceptorHandler,
  )? onError;
}

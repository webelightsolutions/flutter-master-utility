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
    this.successMixPanelEventModel,
    this.errorMixPanelEventModel,
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
  MixPanelEventModel? successMixPanelEventModel;
  MixPanelEventModel? errorMixPanelEventModel;

  void Function(
    DioException dioException,
    ErrorInterceptorHandler errorInterceptorHandler,
  )? onError;
}

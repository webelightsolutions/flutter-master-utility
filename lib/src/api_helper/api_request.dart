part of 'api_service.dart';

class APIRequest {
  APIRequest(
      {this.file,
      this.isAuthorization = true,
      required this.url,
      required this.methodType,
      this.params,
      this.queryParams,
      this.header,
      this.paramList,
      this.onError,
      this.cancelToken,
      this.enableMixpanelTracking,
      this.mixPanelEventModel,
      this.onReceiveProgress,
      this.onSendProgress});

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
  bool? enableMixpanelTracking;
  MixPanelEventModel? mixPanelEventModel;
  void Function(int, int)? onReceiveProgress;
  void Function(int, int)? onSendProgress;

  void Function(
    DioException dioException,
    ErrorInterceptorHandler errorInterceptorHandler,
  )? onError;
}

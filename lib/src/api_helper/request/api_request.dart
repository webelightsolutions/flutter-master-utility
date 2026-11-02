import 'dart:io';

import 'package:dio/dio.dart';
import 'package:master_utility/src/api_helper/request/method_type.dart';

/// Everything needed to send one API call through `APIService`.
class APIRequest {
  APIRequest({
    required this.url,
    required this.methodType,
    Map<String, dynamic>? body,
    List<dynamic>? bodyList,
    Map<String, dynamic>? headers,
    bool? requiresAuth,
    this.queryParams,
    this.onError,
    this.cancelToken,
    this.onReceiveProgress,
    this.onSendProgress,
    this.showHttpLogging = true,
    this.showCurlLogging = true,
    @Deprecated('Has no effect; it was never used.') this.file,

    // Old parameter names: still work, apps see a hint pointing to the new name.
    @Deprecated('Use body instead.') Map<String, dynamic>? params,
    @Deprecated('Use bodyList instead.') List<dynamic>? paramList,
    @Deprecated('Use headers instead.') Map<String, dynamic>? header,
    @Deprecated('Use requiresAuth instead.') bool isAuthorization = true,
  })  : assert(body == null || params == null, 'Pass body or params, not both.'),
        assert(bodyList == null || paramList == null, 'Pass bodyList or paramList, not both.'),
        assert(headers == null || header == null, 'Pass headers or header, not both.'),
        body = body ?? params,
        bodyList = bodyList ?? paramList,
        headers = headers ?? header,
        requiresAuth = requiresAuth ?? isAuthorization;

  String url;
  MethodType methodType;

  /// JSON object sent as the request body (not used for GET).
  Map<String, dynamic>? body;

  /// JSON array sent as the request body. POST prefers it over [body]; PATCH and PUT ignore it.
  List<dynamic>? bodyList;

  Map<String, dynamic>? headers;
  Map<String, dynamic>? queryParams;

  /// Adds `Authorization: Bearer <token>` using the token saved under `HttpHeaders.authorizationHeader`.
  bool requiresAuth;

  CancelToken? cancelToken;
  void Function(int, int)? onReceiveProgress;
  void Function(int, int)? onSendProgress;
  bool showHttpLogging;
  bool showCurlLogging;

  void Function(
    DioException dioException,
    ErrorInterceptorHandler errorInterceptorHandler,
  )? onError;

  @Deprecated('Has no effect; it was never used.')
  File? file;

  @Deprecated('Use body instead.')
  Map<String, dynamic>? get params => body;
  @Deprecated('Use body instead.')
  set params(Map<String, dynamic>? requestBody) => body = requestBody;

  @Deprecated('Use bodyList instead.')
  List<dynamic>? get paramList => bodyList;
  @Deprecated('Use bodyList instead.')
  set paramList(List<dynamic>? requestBodyList) => bodyList = requestBodyList;

  @Deprecated('Use headers instead.')
  Map<String, dynamic>? get header => headers;
  @Deprecated('Use headers instead.')
  set header(Map<String, dynamic>? requestHeaders) => headers = requestHeaders;

  @Deprecated('Use requiresAuth instead.')
  bool get isAuthorization => requiresAuth;
  @Deprecated('Use requiresAuth instead.')
  set isAuthorization(bool shouldAuthorize) => requiresAuth = shouldAuthorize;
}

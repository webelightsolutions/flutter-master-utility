import 'dart:io';

import 'package:dio/dio.dart';
import 'package:master_utility/src/preference_helper.dart';

/// Adds the access token saved in [PreferenceHelper] under `HttpHeaders.authorizationHeader`.
class AuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions requestOptions, RequestInterceptorHandler handler) async {
    final String accessToken = PreferenceHelper.getStringPrefValue(key: HttpHeaders.authorizationHeader);

    requestOptions.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";

    return handler.next(requestOptions);
  }
}

// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:master_utility/master_utility.dart';

class AuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String accessToken = PreferenceHelper.getStringPrefValue(
        key: HttpHeaders.authorizationHeader);

    //options.headers.addAll({"HttpHeaders.authorizationHeader": accessToken});

    options.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";

    return handler.next(options);
  }
}

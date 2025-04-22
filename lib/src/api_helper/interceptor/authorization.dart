// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/secure_token_storage_helper.dart';

class AuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // final String accessToken = PreferenceHelper.getStringPrefValue(
    //     key: HttpHeaders.authorizationHeader);
    final String? accessToken = await SecureTokenStorageHelper.getInstance().accessToken;

    options.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";

    return handler.next(options);
  }
}

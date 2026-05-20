// Project imports:
import 'package:master_utility/master_utility.dart';

class EmailDisposeHelper {
  EmailDisposeHelper._();
  static const String _emailDisposerUrl = "https://disposable.debounce.io/";

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  /// Email Disposer Checker
  static Future<EmailDisposerResModel> emailDisposerChecker({
    required String email,
  }) async {
    try {
      final response = await _dio.get(
        _emailDisposerUrl,
        queryParameters: {'email': email},
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid response format');
      }

      return EmailDisposerResModel.fromJson(data);
    } on DioException {
      rethrow;
    } on FormatException {
      rethrow;
    }
  }
}

class EmailDisposerResModel {
  String? disposable;

  EmailDisposerResModel({this.disposable});

  EmailDisposerResModel.fromJson(Map<String, dynamic> json) {
    disposable = json['disposable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['disposable'] = disposable;
    return data;
  }
}

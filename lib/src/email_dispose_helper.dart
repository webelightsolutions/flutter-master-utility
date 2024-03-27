// Project imports:
import 'package:master_utility/master_utility.dart';

class EmailDisposeHelper {
  static EmailDisposerResModel? _emailDisposerResModel;

  /// Email Disposer Checker
  static Future<EmailDisposerResModel?> emailDisposerChecker(
      {required String email}) async {
    try {
      Response _response = await Dio().get("https://disposable.debounce.io/",
          queryParameters: {"email": email});

      int _responseStatusCode = _response.statusCode ?? 500;

      if (_responseStatusCode >= 200 && _responseStatusCode <= 299) {
        _emailDisposerResModel = EmailDisposerResModel.fromJson(_response.data);
        return _emailDisposerResModel;
      } else {
        ToastHelper.showToast(message: _response.statusMessage.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
    return _emailDisposerResModel;
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

/// Validation error body sent with HTTP 422, e.g. FastAPI's `{"detail": [{"loc": [...], "msg": "...", "type": "..."}]}`.
class ApiErrorModel {
  List<ErrorDetails>? detail;

  ApiErrorModel.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      detail = <ErrorDetails>[];
      json['detail'].forEach((detailJson) {
        detail?.add(ErrorDetails.fromJson(detailJson));
      });
    }
  }
}

class ErrorDetails {
  List<String>? loc;
  String? msg;
  String? type;

  ErrorDetails({this.loc, this.msg, this.type});

  ErrorDetails.fromJson(Map<String, dynamic> json) {
    loc = json['loc'].cast<String>();
    msg = json['msg'];
    type = json['type'];
  }
}

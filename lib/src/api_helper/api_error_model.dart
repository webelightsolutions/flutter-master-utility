class ApiErrorModel {
  List<ErrorDetails>? detail;

  ApiErrorModel({this.detail});

  ApiErrorModel.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      detail = <ErrorDetails>[];
      json['detail'].forEach((v) {
        detail?.add(ErrorDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (detail != null) {
      data['detail'] = detail?.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['loc'] = loc;
    data['msg'] = msg;
    data['type'] = type;
    return data;
  }
}

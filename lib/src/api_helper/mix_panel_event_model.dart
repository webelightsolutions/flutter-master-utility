class MixPanelEventModel {
  String? eventName;
  Map<String, dynamic>? successData;
  Map<String, dynamic>? errorData;

  MixPanelEventModel({this.eventName, this.successData, this.errorData});

  MixPanelEventModel.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    successData = json['successData'] != null ? Map<String, dynamic>.from(json['successData']) : null;
    errorData = json['errorData'] != null ? Map<String, dynamic>.from(json['errorData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventName'] = eventName;
    if (successData != null) {
      data['successData'] = successData;
    }
    if (errorData != null) {
      data['errorData'] = errorData;
    }
    return data;
  }
}

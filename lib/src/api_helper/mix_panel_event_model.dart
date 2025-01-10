class MixPanelEventModel {
  String? eventName;
  Map<String, dynamic>? eventData;

  MixPanelEventModel({this.eventName, this.eventData});

  MixPanelEventModel.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    eventData = json['eventData'] != null ? Map<String, dynamic>.from(json['eventData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventName'] = eventName;
    if (eventData != null) {
      data['eventData'] = eventData;
    }
    return data;
  }
}

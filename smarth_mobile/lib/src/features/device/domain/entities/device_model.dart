import 'dart:convert';

class DeviceModel {
  int? deviceId;
  String? type;
  bool? status;
  int? numLevel;
  List<dynamic>? events;

  DeviceModel({
    this.deviceId,
    this.type,
    this.status,
    this.numLevel,
    this.events,
  });

  factory DeviceModel.fromRawJson(String str) => DeviceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        deviceId: json["deviceId"],
        type: json["type"],
        status: json["status"],
        numLevel: json["numLevel"],
        events: json["events"] == null ? [] : List<dynamic>.from(json["events"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
        "numLevel": numLevel,
      };

  DeviceModel copyWith({
    int? deviceId,
    String? type,
    bool? status,
    int? numLevel,
    List<dynamic>? events,
  }) {
    return DeviceModel(
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      status: status ?? this.status,
      numLevel: numLevel ?? this.numLevel,
      events: events ?? this.events,
    );
  }
}

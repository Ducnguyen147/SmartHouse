import 'dart:convert';

import '../../../device/domain/entities/device_model.dart';

class RoomModel {
  int? roomId;
  List<DeviceModel> devices;
  String? name;
  String? description;
  int? brightness;
  int? occupancy;
  int? oxygenLevel;
  int? temperature;
  bool? livingRoom;

  RoomModel({
    this.roomId,
    this.devices = const [],
    this.name,
    this.description,
    this.brightness,
    this.occupancy,
    this.oxygenLevel,
    this.temperature,
    this.livingRoom,
  });

  factory RoomModel.fromRawJson(String str) => RoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    parseDouble(val) {
      final dval = double.tryParse((val ?? '').toString());
      final toIntVal = dval?.toInt();
      return toIntVal ?? 0;
    }

    return RoomModel(
      // roomId: json["roomId"] as int?,
      roomId: int.tryParse(json["roomId"].toString()) ?? 0,
      devices: json["devices"] == null ? [] : List<DeviceModel>.from(json["devices"]!.map((x) => DeviceModel.fromJson(x))),
      name: json["name"] as String?,
      description: json["description"],
      brightness: int.tryParse(json["brightness"].toString()) ?? 0,
      occupancy: int.tryParse(json["occupancy"].toString()) ?? 0,
      oxygenLevel: parseDouble(json["oxygenLevel"]),
      temperature: parseDouble(json["temperature"]),
      livingRoom: json["livingRoom"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "brightness": brightness,
        "occupancy": occupancy,
        "oxygenLevel": oxygenLevel,
        "temperature": temperature,
        "livingRoom": livingRoom,
      };

  RoomModel copyWith({
    int? roomId,
    List<DeviceModel>? devices,
    String? name,
    String? description,
    int? brightness,
    int? occupancy,
    int? oxygenLevel,
    int? temperature,
    bool? livingRoom,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      devices: devices ?? this.devices,
      name: name ?? this.name,
      description: description ?? this.description,
      brightness: brightness ?? this.brightness,
      occupancy: occupancy ?? this.occupancy,
      oxygenLevel: oxygenLevel ?? this.oxygenLevel,
      temperature: temperature ?? this.temperature,
      livingRoom: livingRoom ?? this.livingRoom,
    );
  }
}

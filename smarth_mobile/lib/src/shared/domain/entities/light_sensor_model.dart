import 'sensor_base_model.dart';

class LightSensorModel extends SensorBaseModel {
  final int lightLevelLux;
  final String lightCondition;

  LightSensorModel({
    required super.sensorId,
    required super.location,
    required super.timestamp,
    required super.batteryLevel,
    required super.signalStrength,
    required this.lightLevelLux,
    required this.lightCondition,
  });

  factory LightSensorModel.fromJson(Map<String, dynamic> json) {
    return LightSensorModel(
      sensorId: json['sensorId'],
      location: json['location'],
      timestamp: json['timestamp'],
      batteryLevel: json['batteryLevel'],
      signalStrength: json['signalStrength'],
      lightLevelLux: json['lightLevelLux'],
      lightCondition: json['lightCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'location': location,
      'timestamp': timestamp,
      'batteryLevel': batteryLevel,
      'signalStrength': signalStrength,
      'lightLevelLux': lightLevelLux,
      'lightCondition': lightCondition,
    };
  }
}

import 'sensor_base_model.dart';

class OccupancySensorModel extends SensorBaseModel {
  final bool presenceDetected;
  final int occupantCount;
  final Map<String, dynamic> environment;

  OccupancySensorModel({
    required super.sensorId,
    required super.location,
    required super.timestamp,
    required super.batteryLevel,
    required super.signalStrength,
    required this.presenceDetected,
    required this.occupantCount,
    required this.environment,
  }); 

  factory OccupancySensorModel.fromJson(Map<String, dynamic> json) {
    return OccupancySensorModel(
      sensorId: json['sensorId'],
      location: json['location'],
      timestamp: json['timestamp'],
      batteryLevel: json['batteryLevel'],
      signalStrength: json['signalStrength'],
      presenceDetected: json['presenceDetected'],
      occupantCount: json['occupantCount'],
      environment: json['environment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'location': location,
      'timestamp': timestamp,
      'batteryLevel': batteryLevel,
      'signalStrength': signalStrength,
      'presenceDetected': presenceDetected,
      'occupantCount': occupantCount,
      'environment': environment,
    };
  }
}

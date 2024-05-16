//   "sensorId": "OCC123456789",
//   "location": "Conference Room A",
//   "timestamp": "2024-03-20T14:30:00Z",
//   "batteryLevel": 95,
//   "signalStrength": "strong"
abstract class SensorBaseModel {
  final String sensorId;
  final String location;
  final String timestamp;
  final int batteryLevel;
  final String signalStrength;
  SensorBaseModel({
    required this.sensorId,
    required this.location,
    required this.timestamp,
    required this.batteryLevel,
    required this.signalStrength,
  });
}

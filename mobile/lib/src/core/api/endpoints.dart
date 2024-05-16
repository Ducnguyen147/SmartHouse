const baseUrl = "192.168.0.159:8080";
const webSocketUrl = 'ws://$baseUrl/gs-guide-websocket';
const httpProtocol = 'http://';
const apiBaseUrl = "$httpProtocol$baseUrl/api";

class Endpoints {
  static const getRoomsApi = "$apiBaseUrl/rooms";
}

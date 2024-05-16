// import 'dart:developer';
// import 'package:stmart_home_elte/src/core/api/endpoints.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;



// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

// main() async {
//   final wsUrl = Uri.parse('ws://example.com');
//   final channel = WebSocketChannel.connect(wsUrl);

//   await channel.ready;

//   channel.stream.listen((message) {
//     channel.sink.add('received!');
//     channel.sink.close(status.goingAway);
//   });
// }

// class SocketService {
//   IO.Socket socket = IO.io(
//       // im using adb so i need to use my wifi ip
//       'http://192.168.62.123:3000',
//       IO.OptionBuilder()
//           .setTransports(['websocket']) // for Flutter or Dart VM
//           .disableAutoConnect() // disable auto-connection
//           // .setExtraHeaders({'foo': 'bar'}) // optional
//           .build());

//   initConnection() {
//     socket.connect();
//     socket.on('connection', (_) {
//       log('connect ${_.toString()}');
//     });
//     log('Trying Connection');
//     socket.onConnect((_) {
//       log('connect');
//     });

//     socket.onerror((_) {
//       log('Error Is ${_.toString()}');
//     });
//   }

//   sendMessage(message) {
//     socket.emit('message', message);
//   }
// }

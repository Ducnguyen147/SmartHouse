import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/presentation/pages/home_page.dart';

import 'src/core/theme/themes.dart';
import 'dart:html';

void main() {
  // SocketService().initConnection();
  runApp(const ProviderScope(child: SmartHomeApp()));
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        fontFamily: 'Baloo',
      ),
      title: 'Smart home simulator',
      home: const HomePage(),
    );
  }
}
// void main() async {
//   const String socketUrl =
//       'ws://localhost:8080/gs-guide-websocket'; // Change IP if needed

//   try {
//     final WebSocket socket = WebSocket(socketUrl);
//     socket.onOpen.listen((event) {
//       print('Connected to $socketUrl');
//       socket.send('Hello, WebSocket!');
//     });

//     socket.onMessage.listen((MessageEvent event) {
//       print('Received: ${event.data}');
//     });

//     socket.onError.listen((event) {
//       print('Error: $event');
//     });

//     socket.onClose.listen((event) {
//       print('Connection closed.');
//     });
//   } catch (e) {
//     print('Failed to connect: $e');
//   }
// }

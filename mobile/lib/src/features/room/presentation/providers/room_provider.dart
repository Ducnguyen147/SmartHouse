import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:developer';

import 'package:riverpod/riverpod.dart';
import 'package:stmart_home_elte/src/core/api/endpoints.dart';
import 'package:stmart_home_elte/src/features/room/application/room_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../domain/entities/room_model.dart';

final roomsProvider = StateNotifierProvider<RoomsNotifier, List<RoomModel>>((ref) {
  final roomService = ref.watch(roomServiceProvider);

  return RoomsNotifier(ref, roomService);
});

class RoomsNotifier extends StateNotifier<List<RoomModel>> {
  final RoomService _roomService;
  final Ref _ref;
  bool isLoading = false;

  RoomsNotifier(this._ref, this._roomService) : super([]) {
    Future.microtask(() async {
      final stompClient = StompClient(
        config: StompConfig(
          url: webSocketUrl,
          beforeConnect: () async {
            log('Trying to connect to the server');
          },
        ),
      );

      stompClient.activate();
      await Future.delayed(const Duration(seconds: 3));

      if (stompClient.connected) {
        log('Connected to the server');
        stompClient.subscribe(
            destination: '/topic/rooms',
            callback: (frame) {
              // log('Received message: ${frame.body.toString()}');
              // final body = jsonDecode(frame.body.toString());
              // log('Received message: $body');
              final jsonResp = jsonDecode(frame.body.toString());
              List<RoomModel> rms = [];
              try {
                rms = jsonResp.map<RoomModel>((e) => RoomModel.fromJson(e)).toList();
              } catch (e) {
                log("error from jsonDecode: $e", name: 'RoomsNotifier.subscribe');
              }
              state = rms;
              log("State changed through websocket");
            });
      } else {
        log('Not connected to the server');
      }
    });
  }

  Future<void> get() async {
    state = await _roomService.getRooms();
    log(state.toString());
  }
}

final roomsFutureProvider = FutureProvider.autoDispose<List<RoomModel>>((ref) async {
  final roomService = ref.watch(roomServiceProvider);
  return roomService.getRooms();
});
